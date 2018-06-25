require 'test_helper'

class FundsWithdrawalTest < ActiveSupport::TestCase
  test "make" do
    o = FundsWithdrawal.make
    assert o.save
  end
  
  test "execute too often" do
    withdrawal = FundsWithdrawal.make! :success=>true
    invalid = FundsWithdrawal.make :user=>withdrawal.user
    assert !invalid.save
  end
  
  test "withraw too much" do
    invalid = FundsWithdrawal.make :amount=>1000
    assert !invalid.save
  end
  
  test "cant withdraw too little" do
    assert true if !FundsWithdrawal::MIN_AMOUNT || FundsWithdrawal::MIN_AMOUNT<0
    invalid = FundsWithdrawal.make :amount=>1 + rand(FundsWithdrawal::MIN_AMOUNT - 1)
    assert !invalid.save
  end
  
  test 'cant withdraw when thers no funds' do
    #deafult user has no auctions and therefore no funds
    invalid = FundsWithdrawal.make :user=>User.make!, :amount=>FundsWithdrawal::MIN_AMOUNT
    assert !invalid.save
  end
  
end
