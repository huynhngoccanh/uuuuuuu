class AuctionOutcomeVendor < ActiveRecord::Base
  belongs_to :auction_outcome
  belongs_to :vendor
  
  validates :auction_outcome_id, :presence=>true
  validates :vendor_id, :presence=>true, :inclusion => { :in => Proc.new{|o| o.auction_outcome.auction.winner_ids} }

  
  attr_accessible :accepted, :comment, :vendor_id

  after_create :accept_or_reject_auction
  after_update :accept_or_reject_auction

  def accept_or_reject_auction
    return if !accepted_changed? || accepted.nil?

    force_accept = false
    if !auction_outcome.confirmed_at.blank? && auction_outcome.confirmed_at + Auction::VENDOR_CANT_REJECT_AFTER < Time.now
      force_accept = true
      errors.add(:accepted, "can't accept or reject auction anymore deadline expired")
    end

    if force_accept || accepted  
      auction_outcome.auction.accept_auction
    else 
      auction_outcome.auction.reject_auction
    end
  end
  
end
