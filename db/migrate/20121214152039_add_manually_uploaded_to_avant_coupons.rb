class AddManuallyUploadedToAvantCoupons < ActiveRecord::Migration
  def change
    add_column :avant_coupons, :manually_uploaded, :boolean
  end
end
