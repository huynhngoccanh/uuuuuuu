class FixStatusesForAuctions < ActiveRecord::Migration
  def up
    Auction.includes(:outcome=>:vendor_outcomes).
      where(:"auctions.status"=>'confirmed').
      where(:"auction_outcome_vendors.accepted"=>true).each do |a|
      
      a.accept_auction
    end
  end
end
