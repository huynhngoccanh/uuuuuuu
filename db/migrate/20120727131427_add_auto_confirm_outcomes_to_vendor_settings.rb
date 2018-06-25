class AddAutoConfirmOutcomesToVendorSettings < ActiveRecord::Migration
  def change
    add_column :vendor_settings, :auto_confirm_outcomes, :boolean
  end
end
