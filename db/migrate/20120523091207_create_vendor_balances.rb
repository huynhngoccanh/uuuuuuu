class CreateVendorBalances < ActiveRecord::Migration
  def change
    create_table :vendor_balances do |t|
      t.integer :vendor_id
      t.integer :total
      t.integer :locked_for_auctions
      t.integer :locked_for_withdrawal
      t.timestamps
    end
  end
end
