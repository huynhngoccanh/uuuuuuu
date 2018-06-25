class AddRecommendedToLoyaltyProgram < ActiveRecord::Migration
   def change
    add_column :loyalty_programs, :recommended, :boolean, default: false
  end
end