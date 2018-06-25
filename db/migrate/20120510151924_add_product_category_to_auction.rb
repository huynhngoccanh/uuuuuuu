class AddProductCategoryToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :product_category_id, :integer
  end
end
