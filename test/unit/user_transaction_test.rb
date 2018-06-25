require 'test_helper'

class UserTransactionTest < ActiveSupport::TestCase
  test "make" do
    #only for accepted
    auction = Bid.make!.auction
    assert !UserTransaction.create_for(auction)
    auction.resolve_auction true, true
    assert !UserTransaction.create_for(auction)
    auction.confirm_auction
    assert !UserTransaction.create_for(auction)
    auction.accept_auction
    assert UserTransaction.create_for(auction)

    assert UserTransaction.create_for(FundsWithdrawal.make! :success=>true)

    visit = ReferredVisit.make!
    assert !UserTransaction.create_for(visit)
    referring_user = visit.user
    referred_user = User.make! :referred_visit=>visit
    auction = Auction.make! :user=>referred_user, :max_vendors=>1
    transfer = FundsTransfer.make!(:successful, :amount=>999)
    VendorTransaction.create_for transfer
    Bid.make! :auction=>auction, :vendor=>transfer.vendor, :max_value=>transfer.amount.to_i
    transfer = FundsTransfer.make!(:successful, :amount=>1000)
    VendorTransaction.create_for transfer
    Bid.make! :auction=>auction, :vendor=>transfer.vendor, :max_value=>transfer.amount.to_i
    auction.resolve_auction true, true
    auction.confirm_auction
    auction.accept_auction
    assert UserTransaction.create_for(visit.reload)

    notification = FundsWithdrawalNotification.make!
    assert_equal notification,  UserTransaction.last.transactable
  end
end
