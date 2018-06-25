class CreatePrintableCoupons < ActiveRecord::Migration
  def change
    create_table :printable_coupons do |t|
      t.integer :user_coupon_id
      t.has_attached_file :coupon_image
      t.timestamps
    end
  end
end
