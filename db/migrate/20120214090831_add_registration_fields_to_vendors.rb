class AddRegistrationFieldsToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :company_name, :string
    add_column :vendors, :first_name, :string
    add_column :vendors, :last_name, :string
    add_column :vendors, :address, :string
    add_column :vendors, :city, :string
    add_column :vendors, :zip_code, :string
    add_column :vendors, :phone, :string
    add_column :vendors, :website_url, :string
    add_column :vendors, :terms, :boolean
  end
end