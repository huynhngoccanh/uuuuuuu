class AddEmailPhoneToUserServiceProviders < ActiveRecord::Migration
  def change
    add_column :user_service_providers, :email, :string
    add_column :user_service_providers, :phone, :string
  end
end
