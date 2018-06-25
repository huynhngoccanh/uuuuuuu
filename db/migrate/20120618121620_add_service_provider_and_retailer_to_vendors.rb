class AddServiceProviderAndRetailerToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :service_provider, :boolean, :default=>false
    add_column :vendors, :retailer, :boolean, :default=>false
  end
end
