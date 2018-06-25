class AddexpireToApiKey < ActiveRecord::Migration
  def change
    add_column :api_keys, :expire, :string
    add_column :api_keys, :device_id, :string
  end
end
