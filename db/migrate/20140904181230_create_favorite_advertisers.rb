class CreateFavoriteAdvertisers < ActiveRecord::Migration
  def change
    create_table :favorite_advertisers do |t|
      t.integer :user_id, :nil => false
      t.integer :cj_advertiser_id
      t.integer :avant_advertiser_id
      t.integer :linkshare_advertiser_id
      t.timestamps
    end

    add_index :favorite_advertisers, :user_id
    add_index :favorite_advertisers, :cj_advertiser_id
    add_index :favorite_advertisers, :avant_advertiser_id
    add_index :favorite_advertisers, :linkshare_advertiser_id
  end
end
