class CreateFundsTransfers < ActiveRecord::Migration
  def change
    create_table :funds_transfers do |t|
      t.integer :vendor_id
      t.integer :amount
      t.string :status
      t.string :paypal_token
      t.string :paypal_payer_id
      t.string :ip_address
      
      t.timestamps
    end
  end
end
