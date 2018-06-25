class CreateLoyaltyProgramCoupons < ActiveRecord::Migration
  def change
    create_table :loyalty_program_coupons do |t|
      t.references :loyalty_program, index: true, foreign_key: true
      t.string :loyalty_program_name
      t.string :header
      t.string :ad_id
      t.string :ad_url
      t.text :description
      t.string :code
      t.date :start_date
      t.date :expires_at
      t.datetime :created_at
      t.datetime :updated_at
      t.boolean :manually_uploaded, default: false

      t.timestamps null: false
    end
  end
end
