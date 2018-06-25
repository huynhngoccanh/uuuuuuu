class CreateProductCategoriesVendors < ActiveRecord::Migration
  def change
    create_table :product_categories_vendors do |t|
      t.integer  :product_category_id
      t.integer  :vendor_id
      
      t.timestamps
    end
  end

end
