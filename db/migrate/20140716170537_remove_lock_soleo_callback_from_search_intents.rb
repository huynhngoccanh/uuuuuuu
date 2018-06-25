class RemoveLockSoleoCallbackFromSearchIntents < ActiveRecord::Migration
  def change
    remove_column :search_intents, :lock_soleo_callback
  end
end
