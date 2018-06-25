class AddDeletedAtToLinkshareCoupon < ActiveRecord::Migration
  def change
  	add_column :linkshare_coupons, :deleted_at, :date
  end
end
