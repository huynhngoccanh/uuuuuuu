class ToAddStatusAndTokenToInviteUsers < ActiveRecord::Migration
  def change
  	add_column :invite_users , :status , :string
  	add_column :invite_users, :token , :string
  end
end
