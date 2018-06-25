class AddMinBidAndFixedBidToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :min_bid, :decimal, :precision => 8, :scale => 2, :after => :max_bid
    add_column :campaigns, :fixed_bid, :decimal, :precision => 8, :scale => 2, :after => :min_bid
  end
end
