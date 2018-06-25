class AddUserIdToUserCoupons < ActiveRecord::Migration
  def up
#    add_reference :user_coupons, :user
    add_column :user_coupons, :admin_approve, :boolean
  end
end
