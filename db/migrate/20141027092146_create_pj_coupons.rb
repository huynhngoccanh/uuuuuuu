class CreatePjCoupons < ActiveRecord::Migration
  def change
    create_table :pj_coupons do |t|
      t.string :advertiser_name
      t.string :advertiser_id
      t.string :header
      t.string :ad_id
      t.string :ad_url
      t.string :description
      t.date :start_date
      t.date :expires_at
      t.string :code
      t.boolean :manually_uploaded
      t.timestamps
    end
  end
end
