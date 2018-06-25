class AddLastUsedToToLoyaltyProgramsUser < ActiveRecord::Migration
  def change
    add_column :loyalty_programs_users, :last_used_at, :date
  end
end
