class AddMobileEnabledToCjAndAvantAdvertisers < ActiveRecord::Migration
  def change
    add_column :cj_advertisers, :mobile_enabled, :boolean
    add_column :avant_advertisers, :mobile_enabled, :boolean
  end
end
