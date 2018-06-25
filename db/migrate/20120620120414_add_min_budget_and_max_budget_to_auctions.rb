class AddMinBudgetAndMaxBudgetToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :budget_min, :integer
    add_column :auctions, :budget_max, :integer
  end
end
