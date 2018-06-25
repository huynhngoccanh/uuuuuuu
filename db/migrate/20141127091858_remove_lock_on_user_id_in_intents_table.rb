class RemoveLockOnUserIdInIntentsTable < ActiveRecord::Migration
  def up
    change_column :search_intents, :user_id, :integer, :null => true
  end

  def down
    change_column :search_intents, :user_id, :integer, :null => false
  end
end
