class AddNumUsedToLoyaltyProgram < ActiveRecord::Migration
  def change
    add_column :loyalty_programs, :num_used, :integer
  end
end
