class ToAddresourceIdandresourceTypeToLike < ActiveRecord::Migration
  def change
  	add_column :likes ,:resource_id ,:integer
  	add_column :likes ,:resource_type ,:string
  end
end
