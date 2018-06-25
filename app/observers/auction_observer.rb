class AuctionObserver < ActiveRecord::Observer
  def after_create(auction)
    AuctionsMailer.delay.auction_initiated_user(auction) if (EmailContent.auction_initiated_user_mail? && auction.user.initiated_auction_mail?)
  end
end
