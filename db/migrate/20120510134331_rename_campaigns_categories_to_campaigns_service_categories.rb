class RenameCampaignsCategoriesToCampaignsServiceCategories < ActiveRecord::Migration
  def up
    rename_table :campaigns_categories, :campaigns_service_categories
  end

  def down
    rename_table :campaigns_service_categories, :campaigns_categories
  end
end
