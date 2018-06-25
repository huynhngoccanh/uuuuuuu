class AddDeletedAtToPjCoupon < ActiveRecord::Migration
  def change
  	add_column :pj_coupons, :deleted_at, :date
  end
end
