class CreateAvantCommissions < ActiveRecord::Migration
  def change
    create_table :avant_commissions do |t|
      t.string :commission_id
      t.integer :avant_offer_id
      t.float :price
      t.float :commission_amount
      t.integer :auction_id_received
      t.datetime :occurred_at
      t.text :params
      t.timestamps
    end
  end
end
