class AddVerifiedToCoupons < ActiveRecord::Migration
  def change
  	add_column :cj_coupons ,:verified ,:boolean ,default:false
  end
end
