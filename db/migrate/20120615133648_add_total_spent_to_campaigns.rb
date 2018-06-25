class AddTotalSpentToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :total_spent, :integer
  end
end
