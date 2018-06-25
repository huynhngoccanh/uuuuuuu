class AddStateAbbreviationToUsersAndVendors < ActiveRecord::Migration
  def change
    add_column :users, :state_abbreviation, :string
    add_column :vendors, :state_abbreviation, :string
  end
end
