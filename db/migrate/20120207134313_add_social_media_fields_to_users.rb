class AddSocialMediaFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :string
    add_column :users, :facebook_token, :string
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_token, :string
    add_column :users, :twitter_secret, :string
    add_column :users, :google_uid, :string
    add_column :users, :google_token, :string
  end
end
