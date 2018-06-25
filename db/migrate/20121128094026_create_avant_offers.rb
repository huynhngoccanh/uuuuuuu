class CreateAvantOffers < ActiveRecord::Migration
  def change
    create_table :avant_offers do |t|
      t.string :name
      t.integer :auction_id
      t.string :advertiser_id
      t.string :advertiser_name
      t.float :price
      t.string :buy_url
      t.float :commission_percent
      t.float :commission_dollars
      t.text :params

      t.timestamps
    end
  end
end
