class AddDesiredTimeToForAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :desired_time_to, :datetime
  end
end
