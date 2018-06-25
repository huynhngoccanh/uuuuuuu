class AddLastNameToLoyaltyProgramsUser < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :last_name, :string
  end
end
