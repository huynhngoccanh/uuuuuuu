class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.string :keyword
      t.integer :user_id
      t.text :presented_link
      t.string :completetion_number
      t.text :completion_callback
      t.decimal :cashback, precision: 10, scale: 5
      t.string :zip

      t.timestamps null: false
    end
  end
end
