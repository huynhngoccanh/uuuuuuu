require 'test_helper'

class FundsTransferTransactionTest < ActiveSupport::TestCase
  class ResponseStruct
    define_method(:success?) { true }
    define_method(:authorization) { '' }
    define_method(:message) { '' }
    define_method(:params) { {'transaction_id'=>'13213123'} }
  end

  test "make" do
    transfer = FundsTransfer.make!(:successful)
    transaction = transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    assert transaction.save
  end
end
