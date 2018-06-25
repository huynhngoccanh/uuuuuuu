class AddCouponHeaderToUserCoupon < ActiveRecord::Migration
  def change
    add_column :user_coupons, :header, :string
    add_column :user_coupons, :offer_header, :string
  end
end
