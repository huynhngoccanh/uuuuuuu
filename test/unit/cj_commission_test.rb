require 'test_helper'

class CjCommissionTest < ActiveSupport::TestCase
  test "make" do
    cj_commission = CjCommission.make
    assert cj_commission.save
  end

  test "commission gets paid" do
    muddleme_transaction_count = MuddlemeTransaction.count
    user_transaction_count = UserTransaction.count
    muddleme_transaction_earnings = MuddlemeTransaction.earnings

    cj_commission = CjCommission.make!

    auction = cj_commission.cj_offer.auction
    #auction not accepted
    assert_equal 'confirmed', auction.status
    assert_equal muddleme_transaction_count + 1, MuddlemeTransaction.count
    assert_equal user_transaction_count + 0, UserTransaction.count
    assert_equal 0, auction.user.balance
    assert_equal cj_commission.commission_amount, MuddlemeTransaction.earnings - muddleme_transaction_earnings

    #auction gets accepted after AFFILIATE_OFFER_ACCEPT_AFTER
    created_at = Time.now - Auction::AFFILIATE_OFFER_ACCEPT_AFTER - 1.second
    Auction.update_all({:created_at=>created_at, :updated_at=>created_at}, {:id=>auction.id})
    auction.outcome.update_attribute :confirmed_at, created_at
    Auction.accept_affiliate_offer_after_waiting_period

    auction = auction.reload

    assert_equal 'accepted', auction.status
    assert_equal muddleme_transaction_count + 2, MuddlemeTransaction.count
    assert_equal user_transaction_count + 1, UserTransaction.count
    user_take = cj_commission.commission_amount * Auction::USER_EARNINGS_SHARE
    muddle_take = cj_commission.commission_amount - user_take
    assert_equal user_take.round(2), auction.user.balance.round(2)
    assert_equal muddle_take.round(2), (MuddlemeTransaction.earnings.to_f - muddleme_transaction_earnings.to_f).round(2)
  end
end
