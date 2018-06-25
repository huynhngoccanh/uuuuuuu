class AddNewRegistrationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :education, :string
    add_column :users, :occupation, :string
    add_column :users, :income_range, :string
    add_column :users, :marital_status, :string
    add_column :users, :family_size, :string
    add_column :users, :home_owner, :boolean
  end
end
