class AddKeywordsFieldToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :keywords, :text
  end
end
