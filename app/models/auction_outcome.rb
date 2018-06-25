class AuctionOutcome < ActiveRecord::Base
  FIRST_CONFIRMATION_REMINDER_AFTER = 7.days
  LAST_CONFIRMATION_BEFORE_DEADLINE = 7.days
  
  belongs_to :auction
  has_many :vendor_outcomes, :class_name=> 'AuctionOutcomeVendor'
  has_many :vendors, :through =>:vendor_outcomes, :dependent=>:destroy
  
  validates :auction_id, :presence=>true
  
  validates :purchase_made, :inclusion => { :in => [true, false] }
  validates :vendor_ids, :presence => true, :if=>Proc.new{|o| o.purchase_made}
  
  attr_accessible :comment, :purchase_made, :vendor_ids
  
  after_update :confirm_intent
  
  private
  
  def confirm_auction
    return unless purchase_made_changed?
    auction.confirm_auction
    auction.reject_auction if !purchase_made
  end
end
