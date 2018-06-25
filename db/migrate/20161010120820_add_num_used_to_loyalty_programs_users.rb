class AddNumUsedToLoyaltyProgramsUsers < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :num_used, :string
  end
end
