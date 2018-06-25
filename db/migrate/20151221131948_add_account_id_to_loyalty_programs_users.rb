class AddAccountIdToLoyaltyProgramsUsers < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :account_id, :string
  end
end
