class ChangeNumUsedFormatInLoyaltyProgramsUsers < ActiveRecord::Migration

  def up
    change_column :loyalty_programs_users, :num_used, :integer
  end

  def down
    change_column :loyalty_programs_users, :num_used, :string
  end
end
