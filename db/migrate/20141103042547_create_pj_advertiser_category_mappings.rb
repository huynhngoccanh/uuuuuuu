class CreatePjAdvertiserCategoryMappings < ActiveRecord::Migration
  def change
    create_table :pj_advertiser_category_mappings do |t|
      t.integer :pj_advertiser_id
      t.integer :product_category_id
      t.boolean :preferred
      t.timestamps
    end
    add_index :pj_advertiser_category_mappings, :pj_advertiser_id, :name => 'index_pj_category_mappings_on_adv_id'
    add_index :pj_advertiser_category_mappings, :product_category_id, :name => 'index_pj_category_mappings_on_product_id'
  end
end
