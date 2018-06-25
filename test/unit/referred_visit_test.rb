require 'test_helper'

class ReferredVisitTest < ActiveSupport::TestCase
  test "make" do
    o = ReferredVisit.make
    assert o.save
  end
  
  test "referred_earnings" do
    earnings_before_test = MuddlemeTransaction.earnings

    visit = ReferredVisit.make!
    referring_user = visit.user
    referred_user = User.make! :referred_visit=>visit
    assert_equal 0, referring_user.balance.to_i
    
    search_intent = Search::Intent.make! :user=>referred_user, :max_vendors=>1 # todo
    transfer = FundsTransfer.make!(:successful, :amount=>999)
    VendorTransaction.create_for transfer
    Bid.make! :auction=>auction, :vendor=>transfer.vendor, :max_value=>transfer.amount.to_i
    transfer = FundsTransfer.make!(:successful, :amount=>1000)
    VendorTransaction.create_for transfer
    Bid.make! :auction=>auction, :vendor=>transfer.vendor, :max_value=>transfer.amount.to_i
    
    assert_equal 0, referring_user.reload.balance.to_i

    search_intent.resolve_intent true, true

    assert_equal 0, MuddlemeTransaction.earnings - earnings_before_test
    assert_equal  0, referring_user.reload.balance.to_i

    search_intent.confirm_intent
    search_intent.accept_intent
    
    assert_equal ReferredVisit::EARNINGS_PER_REFERRED_USER_PERCENTAGE, referring_user.reload.balance.to_i
    assert_equal 300, MuddlemeTransaction.earnings - earnings_before_test
  end
end
