class VendorTransaction < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :transactable, :polymorphic => true

  validates :vendor, :presence=>true
  validates :vendor_id, :presence=>true
  validates :transactable, :presence=>true
  validates :transactable_id, :presence=>true

  before_update {raise ActiveRecord::ReadOnlyRecord}
  before_destroy {raise ActiveRecord::ReadOnlyRecord}

  def self.create_for transactable
    transactable_type = transactable.class.name
    amount = 0
    last_transaction = transactable.vendor.transactions.last
    last_this_type_transaction = transactable.vendor.transactions.where(:transactable_type=>transactable_type).last
    case transactable_type
      when 'Bid'
        return if !['accepted'].include?(transactable.auction.status) || !transactable.is_winning
        amount = -transactable.current_value
      when 'FundsTransfer'
        return if transactable.status.to_s != 'success'
        amount = transactable.amount
      when 'FundsRefund'
        return if !['complete', 'partially_complete'].include?(transactable.status)
        amount = -transactable.refunded_amount
      when 'VendorFundsGrant'
        amount = transactable.amount
    end

    self.create!({
      :vendor=>transactable.vendor,
      :transactable=>transactable,
      :amount=>amount,
      :total_amount=> amount + (last_this_type_transaction.nil? ? 0 : last_this_type_transaction.total_amount),
      :resulting_balance => amount + (last_transaction.nil? ? 0 : last_transaction.resulting_balance)
    })
  end
end
