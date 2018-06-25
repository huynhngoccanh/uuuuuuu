class AddDeletedAtToIrCoupon < ActiveRecord::Migration
  def change
  	add_column :ir_coupons, :deleted_at, :date
  end
end
