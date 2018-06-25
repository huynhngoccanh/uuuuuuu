class AddCampaignIdToBids < ActiveRecord::Migration
  def change
    add_column :bids, :campaign_id, :integer
  end
end
