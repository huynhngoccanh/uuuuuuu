class RanemeAndChangeCjAndAvantProductCategories < ActiveRecord::Migration
  def up
    add_column :cj_advertisers_product_categories, :preferred, :boolean
    rename_table :cj_advertisers_product_categories, :cj_advertiser_category_mappings
    add_column :avant_advertisers_product_categories, :preferred, :boolean
    rename_table :avant_advertisers_product_categories, :avant_advertiser_category_mappings
  end

  def down
    remove_column :cj_advertiser_category_mappings, :preferred
    rename_table :cj_advertiser_category_mappings, :cj_advertisers_product_categories
    remove_column :avant_advertiser_category_mappings, :preferred
    rename_table :avant_advertiser_category_mappings, :avant_advertisers_product_categories
  end
end
