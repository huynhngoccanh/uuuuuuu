class LastseenToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :lastseen, :datetime
  end
end
