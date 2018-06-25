class ChangeResolvedAuctionStatusToUnconfirmed < ActiveRecord::Migration
  def up
    Auction.joins('LEFT JOIN `bids` ON `bids`.`auction_id` = `auctions`.`id`').
       where("status='resolved' AND bids.id is not null").
       update_all({:status=>'unconfirmed'})
    Auction.joins('LEFT JOIN `auction_outcomes` ON `auction_outcomes`.`auction_id` = `auctions`.`id`').
      where(["status='unconfirmed' AND auction_outcomes.id is null"]).each do |a|
      
      o = a.build_outcome
      o.save :validate=>false
    end
      
  end

  def down
  end
end
