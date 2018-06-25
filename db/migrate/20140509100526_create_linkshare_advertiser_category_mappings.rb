class CreateLinkshareAdvertiserCategoryMappings < ActiveRecord::Migration
  def change
    create_table :linkshare_advertiser_category_mappings do |t|
      t.integer :linkshare_advertiser_id
      t.integer :product_category_id
      t.boolean :preferred
    end
    add_index :linkshare_advertiser_category_mappings, :linkshare_advertiser_id, :name => 'index_linkshare_category_mappings_on_adv_id'
    add_index :linkshare_advertiser_category_mappings, :product_category_id, :name => 'index_linkshare_category_mappings_on_product_id'
  end
end
