class CreateAuctionOutcomeVendors < ActiveRecord::Migration
  def change
    create_table :auction_outcome_vendors do |t|
      t.integer :auction_outcome_id
      t.integer :vendor_id
      t.boolean :accepted
      t.text :comment

      t.timestamps
    end
  end
end
