class CreateVendorFundsGrants < ActiveRecord::Migration
  def change
    create_table :vendor_funds_grants do |t|
      t.integer :amount
      t.integer :vendor_id

      t.timestamps
    end
  end
end
