class AddUserIdToUserCouponAgain < ActiveRecord::Migration
  def change
    add_reference :user_coupons, :user
  end
end
