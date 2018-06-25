class AddLoyaltyClassInMerchants < ActiveRecord::Migration
  def change
  	add_column :merchants, :loyalty_class, :string
  end
end
