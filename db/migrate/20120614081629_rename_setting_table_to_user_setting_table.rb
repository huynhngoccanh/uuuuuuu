class RenameSettingTableToUserSettingTable < ActiveRecord::Migration

  def change
    rename_table :settings, :user_settings
  end
end
