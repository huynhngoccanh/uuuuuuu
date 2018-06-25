class FundsRefund < ActiveRecord::Base
  REFUND_POSSIBLE_FOR = 60.days
  
  STATUSES = ['complete', 'partially_complete', 'error']
  
  belongs_to :vendor
  has_and_belongs_to_many :funds_transfers
  has_one :vendor_transaction, :as=>:transactable, :dependent=>:destroy
  
  validates :status, :inclusion => {:in=>STATUSES}, :allow_blank=>true
  validates :requested_amount, :presence=>true, :numericality=>{ :only_integer => true, :greater_than => 0}
  validates_less_or_equal_to_other_attr :requested_amount, :amount_available_for_refund
  
  attr_accessible :requested_amount
  
  def amount_available_for_refund
    where_cond = ['funds_transfers.status = "success" AND funds_transfers.created_at > ?', Time.now - REFUND_POSSIBLE_FOR]
    refundable_amount = vendor.funds_transfers.where(where_cond).sum('amount')
    refundable_amount -= vendor.funds_refunds.includes(:funds_transfers).where(where_cond).map{|r| r.refunded_amount}.sum
    [vendor.available_balance.to_i, refundable_amount].min
  end
  
  def execute
    total_refunded = 0
    
    where_cond = ['status = "success" AND created_at > ?', Time.now - REFUND_POSSIBLE_FOR]
    vendor.funds_transfers.where(where_cond).includes(:transactions, :funds_refunds).order('created_at ASC').each do |transfer|
      transfer_details = transfer.transactions.find_by_action('purchase')
      next if transfer_details.blank?
      
      single_refund_amount = [requested_amount - total_refunded, transfer.amount - transfer.refunded_amount.to_i].min
      next if single_refund_amount <= 0
      
      single_refund_amount_in_cents = (single_refund_amount * 100).round

      if transfer.use_credit_card
        response = CREDIT_CARD_GATEWAY.refund(single_refund_amount_in_cents, transfer_details.params['transaction_id'], {
          :card_number=>transfer.card_last_digits,
          :note => "MuddleMe refund of funds transferred (total funds requested for this refund: #{requested_amount})"
        })
        #try voiding if applicable
        if !response.success? && single_refund_amount == transfer.amount
          transaction = transfer.transactions.create!(:action => "refund", :amount => single_refund_amount_in_cents, :response => response)
          response = CREDIT_CARD_GATEWAY.void(transfer_details.params['transaction_id'], {
            :card_number=>transfer.card_last_digits,
            :note => "MuddleMe refund of funds transferred (total funds requested for this refund: #{requested_amount})"
          })
        end
      else
        response = paypal_express_gateway.refund(single_refund_amount_in_cents, transfer_details.params['transaction_id'], {
          :note => "MuddleMe refund of funds transferred (total funds requested for this refund: #{requested_amount})"
        })
      end
      

      transaction = transfer.transactions.create!(:action => "refund", :amount => single_refund_amount_in_cents, :response => response)
      
      if response.success?
        if transaction.params['total_refunded_amount'].to_i - single_refund_amount != transfer.refunded_amount.to_i
          #TODO send email that the refunding records are wrong
        end

        transfer.funds_refunds << self
        transfer.refunded_amount = transfer.refunded_amount ? transfer.refunded_amount + single_refund_amount : single_refund_amount
        transfer.amount = transfer.amount.to_i
        transfer.save!
        total_refunded += single_refund_amount
      end
      
      break if total_refunded >= requested_amount
    end
    
    update_attribute(:refunded_amount, total_refunded)
    
    if total_refunded == 0
      update_attribute(:status, 'error' )
    else
      update_attribute(:resulting_balance, SystemStats.system_balance - refunded_amount)
      
      update_attribute(:status, total_refunded >= requested_amount ? 'complete' : 'partially_complete')
      
      VendorTransaction.create_for self
    end
    
    
    #partially compete returns true also
    total_refunded != 0
  end
  
  #for testing purposes
  def paypal_express_gateway
    return TEST_EXPRESS_GATEWAY if defined?(TEST_EXPRESS_GATEWAY)
    PAYPAL_EXPRESS_GATEWAY
  end
end
