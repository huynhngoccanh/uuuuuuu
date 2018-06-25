class AddStatusInLoyaltyProgramsUser < ActiveRecord::Migration
  def change
  	add_column :loyalty_programs_users, :status, :string, default: "pending"
  	add_column :loyalty_programs_users, :exception, :text
  	add_column :loyalty_programs_users, :points, :string
  end
end
