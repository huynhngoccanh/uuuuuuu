class RemoveTermsFromUserAndVendor < ActiveRecord::Migration
  def up
    remove_column :users, :terms
    remove_column :vendors, :terms
  end

  def down
    add_column :users, :terms, :boolean
    add_column :vendors, :terms, :boolean
  end
end
