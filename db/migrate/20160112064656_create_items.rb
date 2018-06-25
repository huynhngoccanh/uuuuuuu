class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :model_number
      t.string :sku
      t.string :quantity
      t.string :item_total
      t.string :product_price
      t.references :purchase_history, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
