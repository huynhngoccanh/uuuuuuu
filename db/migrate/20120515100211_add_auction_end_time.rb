class AddAuctionEndTime < ActiveRecord::Migration
  def up
    add_column :auctions, :end_time, :datetime
    Auction.update_all 'end_time = created_at + INTERVAL duration DAY'
  end

  def down
    remove_column :auctions, :end_time, :datetime
  end
end
