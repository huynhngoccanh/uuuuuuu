class AddIsHardcodedToLoyaltyProgramsUsers < ActiveRecord::Migration
  def change
  	add_column :loyalty_programs_users, :is_hardcoded, :boolean ,default:false
  end
end
