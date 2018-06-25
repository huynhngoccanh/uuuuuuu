class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :name
      t.integer :user_id
      t.integer :category_id
      t.string :status
      t.boolean :product_auction, :default=>false
      t.integer :duration
      t.string :budget
      t.integer :min_vendors
      t.integer :max_vendors
      t.datetime :desired_time
      t.datetime :contact_time
      t.datetime :contact_time_to
      t.string :contact_time_of_day
      
      t.string :vendor_restriction
      t.text :extra_info

      t.timestamps
    end
  end
end
