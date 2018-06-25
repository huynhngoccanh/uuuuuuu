class CreateHpStores < ActiveRecord::Migration
  def change
    create_table :hp_stores do |t|
      t.string :store_type
      t.integer :avant_advertiser_id
      t.integer :linkshare_advertiser_id
      t.integer :cj_advertiser_id
      t.integer :pj_advertiser_id
      t.integer :ir_advertiser_id
      t.integer :custom_advertiser_id
      t.timestamps
    end
  end
end
