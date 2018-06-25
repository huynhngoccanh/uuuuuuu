class CreateCampaignsProductCategories < ActiveRecord::Migration
  def change
    create_table :campaigns_product_categories do |t|
      t.integer :campaign_id
      t.integer :product_category_id
      
      t.timestamps
    end
  end

end
