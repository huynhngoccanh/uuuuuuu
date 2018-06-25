class AddColumnsToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :lastseen, :datetime
    add_column :merchants, :view_counter, :integer
  end
end
