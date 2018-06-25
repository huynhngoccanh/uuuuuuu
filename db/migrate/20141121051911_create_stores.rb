class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :address
      t.float :lat
      t.float :lng
      t.integer :storable_id
      t.string  :storable_type
      t.timestamps
    end
  end
end
