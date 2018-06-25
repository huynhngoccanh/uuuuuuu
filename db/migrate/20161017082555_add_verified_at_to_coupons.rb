class AddVerifiedAtToCoupons < ActiveRecord::Migration
  def change
  	add_column :cj_coupons, :verified_at, :datetime
  end
end
