class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :name
      t.integer :vendor_id
      t.boolean :product_offer, :default=>false
      t.string :coupon_code
      t.text :coupon_description
      t.string :offer_url
      t.text :offer_description

      t.timestamps
    end
  end
end
