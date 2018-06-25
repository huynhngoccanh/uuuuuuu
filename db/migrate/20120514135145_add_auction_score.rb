class AddAuctionScore < ActiveRecord::Migration
  def change
    add_column :auctions, :score, :integer
  end
end
