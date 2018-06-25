class AddAuctionClaimedScore < ActiveRecord::Migration
  def change
    add_column :auctions, :claimed_score, :integer
  end
end
