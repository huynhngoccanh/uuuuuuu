class AddDonateEnabledAndSalesOwnerAndSalesNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :donate_enabled, :boolean, :default => true
    add_column :users, :sales_owner, :boolean, :default => false
    add_column :users, :sales_name, :string
  end
end
