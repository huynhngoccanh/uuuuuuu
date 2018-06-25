class AddRegistrationFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :address, :string
    add_column :users, :city, :string
    add_column :users, :zip_code, :string
    add_column :users, :secondary_email, :string
    add_column :users, :phone, :string
    add_column :users, :sex, :string
    add_column :users, :age_range, :string
    add_column :users, :terms, :boolean
  end
end
