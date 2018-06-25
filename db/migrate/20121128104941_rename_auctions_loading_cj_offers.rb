class RenameAuctionsLoadingCjOffers < ActiveRecord::Migration
  def up
    rename_column :auctions, :loading_cj_offers, :loading_affiliate_offers
  end

  def down
    rename_column :auctions, :loading_affiliate_offers, :loading_cj_offers
  end
end
