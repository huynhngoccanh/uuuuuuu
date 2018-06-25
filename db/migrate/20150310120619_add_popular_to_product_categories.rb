class AddPopularToProductCategories < ActiveRecord::Migration
  def change
  	add_column :product_categories, :popular, :boolean , default: false
  end
end
