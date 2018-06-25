class AddMobileCreatedToMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :mobile_created ,:boolean ,default:false
  	add_column :merchants, :user_id ,:integer ,limit: 4
  	
  end
end
