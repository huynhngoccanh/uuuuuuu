class BidObserver < ActiveRecord::Observer
  def after_create(bid)
    if bid.auction.participants.count == 3
      AuctionsMailer.delay.auction_has_some_bids_user(bid.auction) if bid.auction.user.bid_mail?
    end
  end
end
