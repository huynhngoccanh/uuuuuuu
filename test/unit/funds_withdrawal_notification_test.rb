require 'test_helper'

class FundsWithdrawalNotificationTest < ActiveSupport::TestCase
  test "make" do
    notification = FundsWithdrawalNotification.make
    assert notification.save
  end

  test "withdraw if failure" do
    withdrawal = FundsWithdrawal.make! :success=>true
    UserTransaction.create_for withdrawal

    balance_before_cancel = withdrawal.user.balance
    
    notification = FundsWithdrawalNotification.make!({
      :funds_withdrawal => withdrawal,
      :status=>['Failed','Returned','Reversed'].choice
    })

    user = notification.funds_withdrawal.user

    assert_equal( (balance_before_cancel + withdrawal.amount ).round(2), user.balance.round(2) )
    assert_equal 3, user.transactions.count
  end
end
