class CreateSearchBoxMessages < ActiveRecord::Migration
  def change
    create_table :search_box_messages do |t|
      t.text :message
      t.integer :user_id
      t.string :type

      t.timestamps
    end

    add_index :search_box_messages, :user_id
  end
end
