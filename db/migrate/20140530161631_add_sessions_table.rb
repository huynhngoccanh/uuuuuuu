class AddSessionsTable < ActiveRecord::Migration
  def up
    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    change_column :sessions, :data, :text, :limit => 12.megabytes
  end

  def down
    drop_table :sessions
  end
end
