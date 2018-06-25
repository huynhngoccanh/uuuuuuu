class ToaddFacebookBotidToUsers < ActiveRecord::Migration
  def change
  	add_column :users,:user_bot_id, :string,default: :nil
  end
end
