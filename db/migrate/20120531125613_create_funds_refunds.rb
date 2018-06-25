class CreateFundsRefunds < ActiveRecord::Migration
  def change
    create_table :funds_refunds do |t|
      t.integer :vendor_id
      t.integer :requested_amount
      t.integer :refunded_amount
      t.string :status
      t.timestamps
    end
    
    create_table :funds_refunds_funds_transfers do |t|
      t.integer :funds_refund_id
      t.integer :funds_transfer_id
    end
  end
  
end
