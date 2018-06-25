class CreateAuctionAddresses < ActiveRecord::Migration
  def change
    create_table :auction_addresses do |t|
      t.integer :auction_id
      t.string :first_name
      t.string :last_name
      t.string :address
      t.string :city
      t.string :zip_code
      t.timestamps
    end
  end
end
