class ModifyCampaigns < ActiveRecord::Migration
  def up
    remove_column :campaigns, :min_budget
    remove_column :campaigns, :limit_vendors
    remove_column :campaigns, :min_vendors
    remove_column :campaigns, :max_vendors
    remove_column :campaigns, :desired_time
    remove_column :campaigns, :desired_time_to
    remove_column :campaigns, :keywords
    remove_column :campaigns, :adwords
    remove_column :campaigns, :max_per_month
    
    add_column :campaigns, :status, :string
    add_column :campaigns, :budget, :integer
    add_column :campaigns, :score_min, :integer
    add_column :campaigns, :score_max, :integer
  end

  def down
    add_column :campaigns, :min_budget, :integer
    add_column :campaigns, :limit_vendors, :boolean
    add_column :campaigns, :min_vendors, :integer
    add_column :campaigns, :max_vendors, :integer
    add_column :campaigns, :desired_time, :datetime
    add_column :campaigns, :desired_time_to, :datetime
    add_column :campaigns, :keywords, :text
    add_column :campaigns, :adwords, :text
    add_column :campaigns, :max_per_month, :text
    add_column :campaigns, :score, :string
    
    remove_column :campaigns, :status
    remove_column :campaigns, :budget
    remove_column :campaigns, :score_min
    remove_column :campaigns, :score_max
  end
end
