class CreateInviteUsers < ActiveRecord::Migration
  def change
    create_table :invite_users do |t|
      t.integer :user_id
      t.string :email
      t.string :name
      t.timestamps null: false
    end
  end
end
