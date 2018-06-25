class AddMobileEnabledToMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants ,:mobile_enabled ,:boolean ,default:false

  end
end
