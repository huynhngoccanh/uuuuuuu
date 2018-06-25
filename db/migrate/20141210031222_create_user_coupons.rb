class CreateUserCoupons < ActiveRecord::Migration
  def change
    create_table :user_coupons do |t|
      t.integer :advertisable_id
      t.string :advertisable_type
      t.string :store_website
      t.string :offer_type
      t.string :code
      t.text :discount_description
      t.date :expiration_date
      t.timestamps
    end
  end
end
