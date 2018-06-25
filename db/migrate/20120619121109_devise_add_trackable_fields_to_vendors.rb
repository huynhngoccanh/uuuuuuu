class DeviseAddTrackableFieldsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :sign_in_count, :integer, :default => 0
    add_column :vendors, :current_sign_in_at, :datetime
    add_column :vendors, :last_sign_in_at, :datetime
    add_column :vendors, :current_sign_in_ip, :string
    add_column :vendors, :last_sign_in_ip, :string
  end
end
