class CreateFavoriteMerchants < ActiveRecord::Migration
  def change
    create_table :favorite_merchants do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :advertisable_id
      t.string :advertisable_type

      t.timestamps null: false
    end
  end
end
