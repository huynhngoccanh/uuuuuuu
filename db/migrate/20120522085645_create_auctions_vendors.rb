class CreateAuctionsVendors < ActiveRecord::Migration
  def change
    create_table :auctions_vendors do |t|
      t.integer :auction_id
      t.integer :vendor_id
      
      t.timestamps
    end
  end
end
