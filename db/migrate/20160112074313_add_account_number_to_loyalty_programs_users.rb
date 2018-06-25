class AddAccountNumberToLoyaltyProgramsUsers < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :account_number, :string
  end
end
