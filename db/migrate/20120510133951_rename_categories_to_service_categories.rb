class RenameCategoriesToServiceCategories < ActiveRecord::Migration
  def up
    rename_table :categories, :service_categories
  end

  def down
    rename_table :service_categories, :categories
  end
end
