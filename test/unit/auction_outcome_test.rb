require 'test_helper'

class AuctionOutcomeTest < ActiveSupport::TestCase
  test "auction gets confirmed if purchase was made"  do
    auction = Bid.make!.auction
    auction.resolve_auction(true)

    assert_not_nil auction.outcome
    
    auction.outcome.update_attributes :purchase_made=>true, :vendor_ids=>[auction.participants.first.id]
    assert "confirmed", auction.status
  end
end
