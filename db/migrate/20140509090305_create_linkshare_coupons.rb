class CreateLinkshareCoupons < ActiveRecord::Migration
  def change
    create_table :linkshare_coupons do |t|
      t.string :advertiser_name
      t.integer :advertiser_id
      t.string :clickurl
      t.string :header
      t.string :code
      t.text :description
      t.date :expires_at

      t.timestamps
    end
    add_index :linkshare_coupons, :advertiser_id
  end
end
