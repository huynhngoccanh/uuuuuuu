class CreateCampaignsCategories < ActiveRecord::Migration
  def change
    create_table :campaigns_categories do |t|
      t.integer :campaign_id
      t.integer :category_id
      
      t.timestamps
    end
  end
end
