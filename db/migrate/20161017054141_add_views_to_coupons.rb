class AddViewsToCoupons < ActiveRecord::Migration
  def change
  	add_column :cj_coupons, :views, :integer
  	add_column :cj_coupons, :views_updated_at, :date
  end
end
