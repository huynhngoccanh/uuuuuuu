class AddContactWayToAuction < ActiveRecord::Migration
  def change
    add_column :auctions, :contact_way, :string
  end
end
