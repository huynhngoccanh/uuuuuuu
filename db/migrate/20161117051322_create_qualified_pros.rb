class CreateQualifiedPros < ActiveRecord::Migration
  def change
    create_table :qualified_pros do |t|
      t.string :name
      t.string :l_name
      t.string :business_name
      t.boolean :spanish

      t.timestamps null: false
    end
  end
end
