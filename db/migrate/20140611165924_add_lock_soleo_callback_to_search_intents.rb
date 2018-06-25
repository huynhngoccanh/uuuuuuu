class AddLockSoleoCallbackToSearchIntents < ActiveRecord::Migration
  def change
    add_column :search_intents, :lock_soleo_callback, :boolean, :default => false
  end
end
