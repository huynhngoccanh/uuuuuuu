class RenameCouponsToCjCoupons < ActiveRecord::Migration
  def up
    rename_table :coupons, :cj_coupons
  end

  def down
    rename_table :cj_coupons, :coupons
  end
end
