class CreateArchivedBids < ActiveRecord::Migration
  def change
    create_table :archived_bids do |t|
      t.integer :auction_id
      t.integer :vendor_id
      t.integer :value
      t.datetime :bid_at
    end
  end
end
