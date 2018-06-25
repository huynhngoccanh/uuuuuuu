class CreateAvantCoupons < ActiveRecord::Migration
  def change
    create_table :avant_coupons do |t|
      t.string :advertiser_name
      t.string :advertiser_id
      t.string :ad_id
      t.string :ad_url
      t.string :header
      t.string :code
      t.text :description
      t.date :expires_at
      t.timestamps
    end

    add_index :avant_coupons, :ad_id, :unique => true
  end
end
