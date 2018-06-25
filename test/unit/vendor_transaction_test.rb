require 'test_helper'

class VendorTransactionTest < ActiveSupport::TestCase
  class ResponseStruct
    define_method(:success?) { true }
    define_method(:authorization) { '' }
    define_method(:message) { '' }
    define_method(:params) { {'transaction_id'=>'13213123'} }
  end
  
  test "make from bid" do
    bid = Bid.make!
    auction = bid.auction
    auction.resolve_auction true, true
    auction.confirm_auction
    auction.accept_auction
    assert_equal bid, VendorTransaction.last.transactable
  end

  test "make from funds transfer" do
    assert VendorTransaction.create_for(FundsTransfer.make!(:successful))
  end

  test "make from funds refund" do
    transfer = FundsTransfer.make!(:successful)
    transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    VendorTransaction.create_for transfer
    refund = FundsRefund.make! :vendor=>transfer.vendor.reload
    refund.execute
    assert_equal refund, VendorTransaction.last.transactable
  end

  test "make from vendor funds grant" do
    assert VendorTransaction.create_for(VendorFundsGrant.make!)
  end
end
