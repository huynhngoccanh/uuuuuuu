class CreateAvantAdvertisersProductCategories < ActiveRecord::Migration
  def change
    create_table :avant_advertisers_product_categories do |t|
      t.integer :avant_advertiser_id
      t.integer :product_category_id
      
      t.timestamps
    end
  end
end
