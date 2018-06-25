require 'test_helper'

class TransferFeeTest < ActiveSupport::TestCase
  test "fee reduces the balance" do
    expected_balance = SystemStats.system_balance

    funds_transfer = FundsTransfer.make!(:successful)
    expected_balance += funds_transfer.amount
    assert_equal expected_balance, SystemStats.system_balance

    fee = TransferFee.create_for funds_transfer
    expected_balance -= fee.amount
    assert_equal expected_balance.round(2), SystemStats.system_balance
  end
end
