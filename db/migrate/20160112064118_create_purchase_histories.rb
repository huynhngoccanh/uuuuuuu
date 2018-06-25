class CreatePurchaseHistories < ActiveRecord::Migration
  def change
    create_table :purchase_histories do |t|
      t.string :store_address
      t.string :customer_service_pin
      t.string :total
      t.string :product_total
      t.string :sales_tax_fees_surcharges
      t.references :loyalty_programs_user, index: true#, foreign_key: true

      t.timestamps null: false
    end
  end
end
