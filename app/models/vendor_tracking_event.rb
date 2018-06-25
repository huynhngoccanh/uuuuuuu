class VendorTrackingEvent < ActiveRecord::Base
  TYPES = ['clicked', 'visited', 'converted']
  AUCTION_ID_PARAM_NAME = '_muddleme_ref_id'
  belongs_to :vendor
  belongs_to :auction
  
  validates :vendor_id, :presence=>true
  validates :auction_id, :presence=>true
  validates :event_type, :presence=>true, :inclusion => {:in=>TYPES}
  
  after_create :mark_auto_accept
  
  def mark_auto_accept
    return if event_type != 'converted' || !vendor.auto_confirm_outcomes?
    
    if !auction.outcome #create outcome object
      o = auction.build_outcome
      o.save :validate=>false
    end
    
    vendor_outcome = auction.outcome.vendor_outcomes.find_by_vendor_id(vendor.id) || 
      auction.outcome.vendor_outcomes.build
    vendor_outcome.vendor_id = vendor.id
    vendor_outcome.auto_accepted = true
    vendor_outcome.accepted = true unless vendor_outcome.new_record?
    vendor_outcome.save!
  end
  
end
