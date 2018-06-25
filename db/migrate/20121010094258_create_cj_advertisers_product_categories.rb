class CreateCjAdvertisersProductCategories < ActiveRecord::Migration
  def change
    create_table :cj_advertisers_product_categories do |t|
      t.integer :cj_advertiser_id
      t.integer :product_category_id
      
      t.timestamps
    end
  end
end
