class CreateVendorTransactions < ActiveRecord::Migration
  class VendorTransaction < ActiveRecord::Base
    belongs_to :vendor
    belongs_to :transactable, :polymorphic => true

    validates :vendor, :presence=>true
    validates :vendor_id, :presence=>true
    validates :transactable, :presence=>true
    validates :transactable_id, :presence=>true

    #TODO !! only permit creating of transaction (no edit or destroy)

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
  
  def up
    create_table :vendor_transactions do |t|
      t.integer :vendor_id
      t.integer :amount
      t.integer :resulting_balance
      t.integer :transactable_id
      t.string :transactable_type
      t.integer :total_amount

      t.timestamps
    end

    Vendor.find_each do |v|
      bids = v.bids.where(:is_winning=>true).to_a
      funds_transfers = v.funds_transfers.where(:status=>:success).to_a
      funds_refunds = v.funds_refunds.where(:status=>['complete', 'partially_complete']).to_a
      
      all = bids + funds_transfers + funds_refunds
      all.sort_by { |t| t.updated_at}.each do |transactable|
        VendorTransaction.create_for transactable
      end
    end
  end

  def down
    drop_table :vendor_transactions
  end

end
