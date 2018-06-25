class AddAncestryToProductCategory < ActiveRecord::Migration
  def up
    add_column :product_categories, :ancestry, :string
    add_index :product_categories, :ancestry
  end
  
  def down
    remove_index :product_categories, :ancestry
    remove_column :product_categories, :ancestry
  end
end
