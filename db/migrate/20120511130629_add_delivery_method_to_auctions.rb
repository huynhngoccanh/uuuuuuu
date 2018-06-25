class AddDeliveryMethodToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :delivery_method, :string
  end
end
