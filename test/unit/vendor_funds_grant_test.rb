require 'test_helper'

class VendorFundsGrantTest < ActiveSupport::TestCase
  test "make" do
    grant = VendorFundsGrant.make
    assert grant.save
  end

  test "proper balances" do
    earnings_before_test = MuddlemeTransaction.earnings
    grant = VendorFundsGrant.make!
    assert_equal earnings_before_test - grant.amount, MuddlemeTransaction.earnings
    assert_equal grant.vendor.balance, grant.amount
  end
end
