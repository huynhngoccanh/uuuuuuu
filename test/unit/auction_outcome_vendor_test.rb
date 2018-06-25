require 'test_helper'

class AuctionOutcomeVendorTest < ActiveSupport::TestCase
  test "auction gets accepted vendor accepted"  do
    #from auction outcome test
    auction = Bid.make!.auction
    auction.resolve_auction(true)

    assert_not_nil auction.outcome
    auction.outcome.update_attributes :purchase_made=>true, :vendor_ids=>[auction.participants.first.id]
    assert "confirmed", auction.status

    assert_not_nil auction.outcome.vendor_outcomes.first
    vendor_outcome = auction.outcome.vendor_outcomes.first
    vendor_outcome.update_attributes :accepted=>true

    assert "accepted", auction.status
  end

  test "auction gets rejected if vendor rejected"  do
    #from auction outcome test
    auction = Bid.make!.auction
    auction.resolve_auction(true)

    assert_not_nil auction.outcome
    auction.outcome.update_attributes :purchase_made=>true, :vendor_ids=>[auction.participants.first.id]
    assert "confirmed", auction.status

    assert_not_nil auction.outcome.vendor_outcomes.first
    vendor_outcome = auction.outcome.vendor_outcomes.first
    vendor_outcome.update_attributes :accepted=>false

    assert "rejected", auction.status
  end
end
