class CreateLoyaltyProgramOfferImages < ActiveRecord::Migration
  def change
    create_table :loyalty_program_offer_images do |t|
      t.references :loyalty_program, index: true, foreign_key: true
      t.references :loyalty_program_offer, index: true, foreign_key: true
      t.datetime :image_updated_at
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size

      t.timestamps null: false
    end
  end
end
