class AddDeletedAtToAvantCoupon < ActiveRecord::Migration
  def change
  	add_column :avant_coupons, :deleted_at, :date
  end
end
