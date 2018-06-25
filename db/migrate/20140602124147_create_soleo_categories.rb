class CreateSoleoCategories < ActiveRecord::Migration
  def change
    create_table :soleo_categories do |t|
      t.string :name, :null => false
      t.integer :soleo_id, :null => false
      t.string  :ancestry
      t.integer :ancestry_depth, :default => 0

      t.timestamps
    end
    add_index :soleo_categories, [:soleo_id, :ancestry_depth], :unique => true
  end
end
