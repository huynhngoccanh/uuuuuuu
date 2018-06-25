class RenameCategoriesVendorsToServiceCategoriesVendors < ActiveRecord::Migration
  def up
    rename_table :categories_vendors, :service_categories_vendors
  end

  def down
    rename_table :service_categories_vendors, :categories_vendors
  end
end
