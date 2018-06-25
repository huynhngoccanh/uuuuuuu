class CreateIrAdvertiserCategoryMappings < ActiveRecord::Migration
  def change
    create_table :ir_advertiser_category_mappings do |t|
      t.integer :ir_advertiser_id
      t.integer :product_category_id
      t.boolean :preferred
      t.timestamps
    end
    add_index :ir_advertiser_category_mappings, :ir_advertiser_id, :name => 'index_ir_category_mappings_on_adv_id'
    add_index :ir_advertiser_category_mappings, :product_category_id, :name => 'index_ir_category_mappings_on_product_id'
  end
end
