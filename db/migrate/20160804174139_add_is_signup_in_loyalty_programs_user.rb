class AddIsSignupInLoyaltyProgramsUser < ActiveRecord::Migration
  def change
  	add_column :loyalty_programs_users, :is_signup, :boolean, default: false
  end
end
