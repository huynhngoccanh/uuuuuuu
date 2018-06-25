require 'test_helper'

class ArchivedBidTest < ActiveSupport::TestCase
  test "bids get archived after update" do
    bid = Bid.make!
    bid.update_attributes :max_value=>bid.max_value.to_i + Auction.new.bid_value_step
    archived_bid = ArchivedBid.last
    assert bid.max_value, archived_bid.max_value
    assert bid.vendor_id, archived_bid.vendor_id
  end
end
