class ViewcounterToMerchant < ActiveRecord::Migration
  def change
    add_column :merchants, :view_counter, :integer
  end
end
