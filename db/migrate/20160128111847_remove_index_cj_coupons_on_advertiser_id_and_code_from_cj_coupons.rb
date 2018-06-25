class RemoveIndexCjCouponsOnAdvertiserIdAndCodeFromCjCoupons < ActiveRecord::Migration
  def change
    remove_index :cj_coupons,:name => 'index_cj_coupons_on_advertiser_id_and_code'
  end
end
