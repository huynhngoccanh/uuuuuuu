class AddLoyaltyEnabledInMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :loyalty_enabled, :boolean, default: false
  end
end
