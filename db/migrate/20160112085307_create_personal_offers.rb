class CreatePersonalOffers < ActiveRecord::Migration
  def change
    create_table :personal_offers do |t|
      t.string :header
      t.attachment :offer_video
      t.attachment :offer_barcode_image
      t.datetime :expiration_date
      t.references :loyalty_program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
