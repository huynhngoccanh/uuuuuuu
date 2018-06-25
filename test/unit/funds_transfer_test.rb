require 'test_helper'

class FundsTransferTest < ActiveSupport::TestCase
  test "make" do
    o = FundsTransfer.make
    assert o.save
  end
  
  test "setup_paypal_purchase" do
    transfer = FundsTransfer.make!
    url_1 = Faker::Internet::url
    url_2 = Faker::Internet::url
    transfer.setup_paypal_purchase(url_1, url_2)
    
    assert_equal transfer.transactions.count, 1
    assert_not_nil transfer.paypal_token
    assert transfer.paypal_token, transfer.paypal_redirect_url
  end
  
  test 'failed execute' do
    transfer = FundsTransfer.make!(
      :ip_address => Faker::Internet::ip_v4_address,
      :paypal_token => 'sometoken',
      :paypal_payer_id => 'somepayerid')
    
    result = transfer.execute
    assert !result
    assert_equal transfer.transactions.count, 1
    assert_equal transfer.vendor.balance.to_i, 0
  end
  
  test 'make successful' do
    transfer = FundsTransfer.make(:successful)
    assert transfer.save
    assert_equal transfer.amount, transfer.vendor.calculated_balance
  end
  
end
