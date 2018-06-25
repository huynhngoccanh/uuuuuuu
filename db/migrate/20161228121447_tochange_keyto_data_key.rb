class TochangeKeytoDataKey < ActiveRecord::Migration
  def change
  	rename_column :storebotdata ,:key, :datakey
  end
end
