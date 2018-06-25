class AddAutoAcceptedToAuctionOutcomeVendors < ActiveRecord::Migration
  def change
    add_column :auction_outcome_vendors, :auto_accepted, :boolean
  end
end
