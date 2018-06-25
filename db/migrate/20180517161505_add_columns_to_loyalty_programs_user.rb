class AddColumnsToLoyaltyProgramsUser < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :created_at, :datetime
    add_column :loyalty_programs_users, :updated_at, :datetime
  end
end
