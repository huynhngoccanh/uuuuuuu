class AddFavouriteBrowserFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :favourite_browser_name, :string
    add_column :users, :favourite_browser_major_version, :string
  end
end
