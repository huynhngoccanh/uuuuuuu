class RenameCategoryCoulmnInCampaignsServiceCategories < ActiveRecord::Migration
  def up
    rename_column :campaigns_service_categories, :category_id, :service_category_id
  end

  def down
    rename_column :campaigns_service_categories, :service_category_id, :category_id
  end
end
