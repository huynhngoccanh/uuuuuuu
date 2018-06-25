class AddPasswordToLoyaltyProgramsUser < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :password, :string
  end
end
