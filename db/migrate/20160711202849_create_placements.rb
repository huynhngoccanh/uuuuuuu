class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.integer :merchant_id
      t.string :location
      t.text :description
      t.string :code
      t.date :expiry

      t.timestamps null: false
    end
  end
end
