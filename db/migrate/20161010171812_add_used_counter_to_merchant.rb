class AddUsedCounterToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :used_counter, :integer
  end
end
