class Toaddlatandlong < ActiveRecord::Migration
  def change
  	add_column :users, :c_lat,:string
  	add_column :users, :c_long,:string
  	add_column :users, :updated_location,:datetime
  end
end
