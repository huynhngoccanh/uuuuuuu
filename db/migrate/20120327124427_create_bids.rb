class CreateBids < ActiveRecord::Migration
  def change
    create_table :bids do |t|
      t.integer :auction_id
      t.integer :vendor_id
      t.boolean :is_winning, :default=>false
      t.integer :value
      t.timestamps
    end
  end
end
