require 'test_helper'

class SystemStatsTest < ActiveSupport::TestCase
  test "balance for funds transfer" do
    expected_balance = SystemStats.system_balance

    funds_transfer = FundsTransfer.make!(:successful)

    expected_balance += funds_transfer.amount
    assert_equal expected_balance, SystemStats.system_balance
  end

  test "balance for fund refund" do
    funds_refund = FundsRefund.make!
    expected_balance = SystemStats.system_balance
    funds_refund.execute
    expected_balance -= funds_refund.refunded_amount
    assert_equal expected_balance, SystemStats.system_balance
  end  

  test "balance for cj commission" do
    expected_balance = SystemStats.system_balance
    cj_commission = CjCommission.make!
    expected_balance += cj_commission.commission_amount
    assert_equal expected_balance, SystemStats.system_balance
  end

  test "balance for avant commission" do
    expected_balance = SystemStats.system_balance
    avant_commission = AvantCommission.make!
    expected_balance += avant_commission.commission_amount
    assert_equal expected_balance, SystemStats.system_balance
  end
end
