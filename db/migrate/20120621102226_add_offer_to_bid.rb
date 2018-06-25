class AddOfferToBid < ActiveRecord::Migration
  def change
    add_column :bids, :offer_id, :integer
  end
end
