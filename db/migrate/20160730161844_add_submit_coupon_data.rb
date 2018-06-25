class AddSubmitCouponData < ActiveRecord::Migration
  def change
  	add_column :cj_coupons, :temp_website, :string
  	add_column :cj_coupons, :user_id, :string
  	add_column :cj_coupons, :coupon_type, :string
  	add_attachment :cj_coupons, :print
  end
end
