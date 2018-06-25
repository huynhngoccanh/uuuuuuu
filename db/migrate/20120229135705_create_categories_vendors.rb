class CreateCategoriesVendors < ActiveRecord::Migration
  def change
    create_table :categories_vendors do |t|
      t.integer :category_id
      t.integer :vendor_id
      
      t.timestamps
    end
  end
end
