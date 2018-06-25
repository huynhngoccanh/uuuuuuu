class ToaddColumncurrentLocation < ActiveRecord::Migration
  def change
  	add_column :users ,:current_loc,:string
  end
end
