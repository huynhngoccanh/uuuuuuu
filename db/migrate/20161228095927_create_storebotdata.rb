class CreateStorebotdata < ActiveRecord::Migration
  def change
    create_table :storebotdata do |t|
      t.string :user_id
      t.string :key
      t.string :value

      t.timestamps null: false
    end
  end
end
