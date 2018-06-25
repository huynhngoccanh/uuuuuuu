class CreateSalesGroups < ActiveRecord::Migration
  def change
    create_table :sales_groups do |t|
      t.string :name
      t.integer :user_id, :null => false

      t.timestamps
    end

    add_index :sales_groups, :user_id
  end
end
