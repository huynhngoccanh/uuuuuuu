class CreateUserServiceProviders < ActiveRecord::Migration
  def change
    create_table :user_service_providers do |t|
      t.references :user
      t.string :merchant_name
      t.string :merchant_address
      t.timestamps
    end
  end
end
