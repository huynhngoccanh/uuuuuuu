require 'test_helper'

class MuddlemeTransactionTest < ActiveSupport::TestCase
  test "make" do
    assert MuddlemeTransaction.create_for(AvantCommission.make!)
    assert MuddlemeTransaction.create_for(CjCommission.make!)

    #only for accepted
    auction = Bid.make!.auction
    assert !MuddlemeTransaction.create_for(auction)
    auction.resolve_auction true, true
    assert !MuddlemeTransaction.create_for(auction)
    auction.confirm_auction
    assert !MuddlemeTransaction.create_for(auction)
    auction.accept_auction
    assert MuddlemeTransaction.create_for(auction)

    grant = VendorFundsGrant.make!
    assert MuddlemeTransaction.last.amount, grant.amount
  end
end
