class AddStorepasswordToUser < ActiveRecord::Migration
  def change
    add_column :users, :storepassword, :string
  end
end
