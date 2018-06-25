class AddSocialMediaFieldsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :facebook_uid, :string
    add_column :vendors, :facebook_token, :string
    add_column :vendors, :twitter_uid, :string
    add_column :vendors, :twitter_token, :string
    add_column :vendors, :twitter_secret, :string
    add_column :vendors, :google_uid, :string
    add_column :vendors, :google_token, :string
  end
end
