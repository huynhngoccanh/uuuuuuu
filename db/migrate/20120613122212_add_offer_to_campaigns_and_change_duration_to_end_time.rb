class AddOfferToCampaignsAndChangeDurationToEndTime < ActiveRecord::Migration
  def up
    add_column :campaigns, :offer_id, :integer
    add_column :campaigns, :stop_at, :datetime
    remove_column :campaigns, :duration
  end
  
  def down
    remove_column :campaigns, :offer_id
    remove_column :campaigns, :stop_at
    add_column :campaigns, :duration, :integer
  end
end
