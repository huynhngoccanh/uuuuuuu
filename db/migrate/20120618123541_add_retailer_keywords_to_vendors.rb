class AddRetailerKeywordsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :retailer_keywords, :text
  end
end
