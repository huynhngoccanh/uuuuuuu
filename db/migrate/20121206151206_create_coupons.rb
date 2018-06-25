class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :header
      t.string :code
      t.text :description
      t.date :expires_at
      t.integer :advertiser_id
      t.string :advertiser_type
      t.boolean :manually_uploaded, default: false
      t.integer :merchant_id
      t.string :ad_url

      t.timestamps null: false
    end
  end
end
