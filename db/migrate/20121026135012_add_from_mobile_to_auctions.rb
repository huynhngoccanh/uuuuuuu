class AddFromMobileToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :from_mobile, :boolean
  end
end
