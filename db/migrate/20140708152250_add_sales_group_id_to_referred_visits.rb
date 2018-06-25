class AddSalesGroupIdToReferredVisits < ActiveRecord::Migration
  def change
    add_column :referred_visits, :sales_group_id, :integer
  end
end
