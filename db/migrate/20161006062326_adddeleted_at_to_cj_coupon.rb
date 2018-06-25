class AdddeletedAtToCjCoupon < ActiveRecord::Migration
  def change
  	add_column :cj_coupons, :deleted_at, :date
  end
end
