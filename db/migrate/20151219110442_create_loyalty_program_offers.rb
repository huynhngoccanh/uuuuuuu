class CreateLoyaltyProgramOffers < ActiveRecord::Migration
  def change
    create_table :loyalty_program_offers do |t|
      t.references :loyalty_program
      t.string :name
      t.string :coupon_code
      t.string :offer_url
      t.text :offer_description
      t.datetime :expiration_time
      t.boolean :product_offer
      t.decimal :total_spent, precision: 8, scale: 2
      t.attachment :offer_video
      t.datetime :deleted_at
      t.boolean :is_deleted

      t.timestamps null: false
    end
    add_index :loyalty_program_offers, :loyalty_program_id, where: "deleted_at IS NULL"
  end
end
