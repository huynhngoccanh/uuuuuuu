class RenameCategoryCoulmnInServiceCategoriesVendors < ActiveRecord::Migration
  def up
    rename_column :service_categories_vendors, :category_id, :service_category_id
  end

  def down
    rename_column :service_categories_vendors, :service_category_id, :category_id
  end
end
