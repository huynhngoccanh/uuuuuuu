class CreateUserFavourites < ActiveRecord::Migration
  def change
    create_table :user_favourites do |t|
      t.integer :user_id
      t.integer :resource_id
      t.string :resource_type

      t.timestamps null: false
    end
  end
end
