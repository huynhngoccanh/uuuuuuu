class AddPostToSocialToUserSettings < ActiveRecord::Migration
  def change
    add_column :user_settings, :post_to_social, :boolean
  end
end
