class ChangeDescriptionColumnOfPjCoupons < ActiveRecord::Migration
  def change
    change_column :pj_coupons, :description, :text
  end
end
