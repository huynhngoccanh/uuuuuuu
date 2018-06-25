class CreateHpStoreProductCategories < ActiveRecord::Migration
  def change
    create_table :hp_store_product_categories do |t|
      t.references :hp_store, index: true, foreign_key: true
      t.references :product_category, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
