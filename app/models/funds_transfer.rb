class FundsTransfer < ActiveRecord::Base
  STATUSES = ['success', 'refunded', 'error_setup_purchase', 'error_making_purchase']
  MIN_AMOUNT = 20
  
  belongs_to :vendor
  has_many :transactions, :class_name => "FundsTransferTransaction"
  has_and_belongs_to_many :funds_refunds
  has_one :vendor_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :transfer_fee, :as=>:feeable, :dependent=>:destroy
  
  validates :vendor_id, :presence => true
  validates :status, :inclusion => {:in=>STATUSES}, :allow_blank=>true
  validates :amount, :presence=>true, :numericality=>{ :greater_than_or_equal_to => MIN_AMOUNT, :only_integer => true}
  
  validate :validate_card, :on=>:create
  
  before_validation(:on => :create) do
    if use_credit_card
      self.card_last_digits = card_number[-4..-1]
    end
  end
  
  attr_accessor :card_number, :card_verification_value, :card_year, :card_month
  attr_reader :response
  
  attr_accessible :amount, :use_credit_card, :card_number, :card_year, :card_month, :card_verification_value,
     :card_first_name, :card_last_name, :card_type
  
  def amount_in_cents
    (amount * 100).round
  end
  
  def setup_paypal_purchase return_url, cancel_url
    response = PAYPAL_EXPRESS_GATEWAY.setup_purchase(amount_in_cents,
      :ip                => ip_address,
      :return_url        => return_url,
      :cancel_return_url => cancel_url
    ) 
    if response.success?
      update_attribute :paypal_token, response.token
    else
      update_attribute(:status, 'error_setup_purchase')
    end
    transactions.create!(:action => "prepare_purchase", :amount => amount_in_cents, :response => response)
    response.success?
  end
  
  def paypal_redirect_url
    PAYPAL_EXPRESS_GATEWAY.redirect_url_for(paypal_token)
  end
  
  def execute
    if use_credit_card
      @response = CREDIT_CARD_GATEWAY.purchase(amount_in_cents, credit_card, {
        :ip => ip_address,
      })
    else
      @response = PAYPAL_EXPRESS_GATEWAY.purchase(amount_in_cents, {
        :ip => ip_address,
        :token => paypal_token,
        :payer_id => paypal_payer_id
      })
    end
    
    #save gateways response details so there is a log of what happened
    transactions.create!(:action => "purchase", :amount => amount_in_cents, :response => @response)
    if @response.success?
      update_attribute(:resulting_balance, SystemStats.system_balance + amount)
      update_attribute(:status, 'success')
      VendorTransaction.create_for self
      TransferFee.create_for self
    else
      update_attribute(:status, 'error_making_purchase')
    end
    @response.success?
  end
  
  def save_paypal_transaction_details
    details = PAYPAL_EXPRESS_GATEWAY.details_for(paypal_token)
    update_attribute(:paypal_payer_id, details.payer_id)
    # ?? save first last name and other stuff here ???
    # what is nedded to be shown on confirmation page
  end
  
  def validate_card
    return unless use_credit_card
    
    unless credit_card.valid?
      credit_card.errors.each do |field, e_array|
        e_array.each {|e| errors.add :"card_#{field}", e}
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification_value,
      :year               => card_year,
      :month              => card_month,
      :first_name         => card_first_name,
      :last_name          => card_last_name
    )
  end
  
end
