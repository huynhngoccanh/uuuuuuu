class AddBlockedToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :blocked, :boolean, :default => false
  end
end
