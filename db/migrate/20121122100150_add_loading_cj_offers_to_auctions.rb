class AddLoadingCjOffersToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :loading_cj_offers, :boolean
  end
end
