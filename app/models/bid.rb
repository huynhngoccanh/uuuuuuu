class Bid < ActiveRecord::Base
  
  belongs_to :auction
  belongs_to :vendor
  
  belongs_to :campaign
  belongs_to :offer
  has_one :vendor_transaction, :as=>:transactable, :dependent=>:destroy
  
  accepts_nested_attributes_for :offer
  
  validates :auction_id, :presence=>true, :uniqueness => {:scope=>[:vendor_id]}
  validates :vendor_id, :presence=>true
  validates :max_value, :presence=>true, :numericality=>{ :greater_than => 0, :only_integer => true}
  validates_greather_or_equal_to_other_attr :max_value, :minimum_value
  validates_less_or_equal_to_other_attr :max_value, :vendor_balance
  validate :cant_bid_if_auction_time_is_up
  
  #todo validate that bid cannot have vendor or auction changed by update
  
  after_update :archive_bid
  
  attr_accessible :max_value, :offer_id, :offer_attributes
  
  after_save do
    if campaign_id.nil?
      update_current_value 
      auction.autobid_campaigns
    end
  end
  
  def vendor_balance
    vendor.available_balance auction, campaign
  end
  
  def minimum_value
    auction.bid_minimum_value
  end
  
  def minimum_value= val
  end
  
  def update_current_value
    return if !max_value_changed? || current_value_changed?
    auction.update_bids_current_values
  end
  
  def archive_bid
    ArchivedBid.create({
        :auction_id => auction_id,
        :vendor_id => vendor_id,
        :max_value => max_value_was,
        :bid_at => updated_at_was
      })
  end
  
  def cant_bid_if_auction_time_is_up
    if auction.bidding_finished?
      errors.add(:max_value, "bidding is finished for this auction")
    end
  end

  def to_api_json
    attrs = Bid.attribute_names
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:vendor] = vendor.company_name
    result[:vendor_email] = vendor.email
    result[:vendor_phone] = vendor.phone
    result[:bid_at] = updated_at
    bid_offer = offer || (campaign && campaign.offer)
    result[:offer]  = bid_offer && bid_offer.to_api_json
    if auction.outcome && auction.outcome.vendor_outcomes
      result[:preaccepted_outcome] = 
        !auction.outcome.vendor_outcomes.to_a.select{|v| v.vendor_id==vendor.id && v.auto_accepted }.blank?
    end
    result
  end
end
