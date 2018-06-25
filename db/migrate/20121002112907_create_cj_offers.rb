class CreateCjOffers < ActiveRecord::Migration
  def change
    create_table :cj_offers do |t|
      t.string :name
      t.integer :auction_id
      t.string :ad_id
      t.string :advertiser_id
      t.string :advertiser_name
      t.float :price
      t.string :buy_url
      t.text :params

      t.timestamps
    end
  end
end
