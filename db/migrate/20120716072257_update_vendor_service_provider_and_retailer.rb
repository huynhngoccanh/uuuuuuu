class UpdateVendorServiceProviderAndRetailer < ActiveRecord::Migration
  def up
    Vendor.joins(:service_categories).update_all({:service_provider=>true})
    Vendor.joins(:product_categories).update_all({:retailer=>true})
  end

  def down
  end
end
