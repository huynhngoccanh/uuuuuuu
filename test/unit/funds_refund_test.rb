require 'test_helper'

class FundsRefundTest < ActiveSupport::TestCase
  class ResponseStruct
    define_method(:success?) { true }
    define_method(:authorization) { '' }
    define_method(:message) { '' }
    define_method(:params) { {'transaction_id'=>'13213123'} }
  end
  
  test "make" do
    o = FundsRefund.make
    assert o.save
  end
  
  test "execute" do
    transfer = FundsTransfer.make!(:successful)

    transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    VendorTransaction.create_for transfer
    refund = FundsRefund.make! :vendor=>transfer.vendor.reload

    assert refund.execute
    assert_equal'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal refund.vendor.funds_transfers, refund.funds_transfers
    assert_equal transfer.amount - refund.refunded_amount, refund.vendor.reload.balance
  end
  
  
  test "many tansfers one full withdrawal" do
    vendor = Vendor.make!
    3.times do
      transfer = FundsTransfer.make!(:successful , :vendor=>vendor)
      VendorTransaction.create_for transfer
      transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    end
    refund = FundsRefund.make! :requested_amount => vendor.balance.to_i, :vendor=>vendor
    
    assert refund.execute

    vendor = vendor.reload

    assert_equal 'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal refund.vendor.funds_transfers, refund.funds_transfers
    assert_equal 0, refund.vendor.reload.balance
  end
  
  test "three tansfers two withdrawals from all transfers than using the one remaining" do
    vendor = Vendor.make!
    3.times do
      transfer = FundsTransfer.make!(:successful , :vendor=>vendor, :amount=>50)
      VendorTransaction.create_for transfer
      transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    end
    vendor.update_attribute :balance, vendor.calculated_balance
    
    refund = FundsRefund.make! :requested_amount => 120, :vendor=>vendor
    assert refund.execute
    assert_equal'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal 30, refund.amount_available_for_refund
    assert_equal 30, refund.vendor.reload.balance
    
    refund = FundsRefund.make! :requested_amount => 30, :vendor=>vendor
    assert refund.execute
    assert_equal'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal [refund.vendor.funds_transfers.order('created_at ASC, id ASC').last], refund.funds_transfers.to_a
    assert_equal 0, refund.vendor.reload.balance
  end
  
  test "three tansfers two withdrawals from first transfer than using two remaining" do
    vendor = Vendor.make!
    3.times do
      transfer = FundsTransfer.make!(:successful , :vendor=>vendor, :amount=>50)
      VendorTransaction.create_for transfer
      transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    end
    vendor.update_attribute :balance, vendor.calculated_balance
    
    first_transfer = vendor.funds_transfers.order('created_at ASC, id ASC').first
    second_transfer = vendor.funds_transfers.order('created_at ASC, id ASC')[1]
    last_transfer = vendor.funds_transfers.order('created_at ASC, id ASC').last
    
    refund = FundsRefund.make! :requested_amount => 20, :vendor=>vendor
    assert refund.execute
    assert_equal'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal [refund.vendor.funds_transfers.order('created_at ASC, id ASC').first], refund.funds_transfers.to_a
    assert_equal 130, refund.amount_available_for_refund
    assert_equal 130, refund.vendor.reload.balance
    
    refund2 = FundsRefund.make! :requested_amount => 120, :vendor=>vendor
    assert refund2.execute
    assert_equal'complete', refund2.status
    assert_equal refund2.requested_amount, refund2.refunded_amount
    assert_equal refund2.vendor.funds_transfers, refund2.funds_transfers
    assert_equal [refund, refund2], first_transfer.reload.funds_refunds.to_a
    assert_equal [refund2], second_transfer.reload.funds_refunds.to_a
    assert_equal [refund2], last_transfer.reload.funds_refunds.to_a
    assert_equal 10, refund2.amount_available_for_refund
    assert_equal 10, refund2.vendor.reload.balance
    assert_equal 40, last_transfer.refunded_amount
    
    refund3 = FundsRefund.make! :requested_amount => 10, :vendor=>vendor
    assert refund3.execute
    assert_equal'complete', refund3.status
    assert_equal refund3.requested_amount, refund3.refunded_amount
    assert_equal [last_transfer], refund3.funds_transfers
    assert_equal [refund2], second_transfer.reload.funds_refunds.to_a
    assert_equal [refund2, refund3], last_transfer.reload.funds_refunds.to_a
    assert_equal 50, last_transfer.refunded_amount
    assert_equal 0, refund3.amount_available_for_refund
    assert_equal 0, refund3.vendor.reload.balance
  end
  
  test "three tansfers two withdrawals from first and second transfers than from second and third" do
    vendor = Vendor.make!
    3.times do
      transfer = FundsTransfer.make!(:successful , :vendor=>vendor, :amount=>50)
      VendorTransaction.create_for transfer
      transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    end
    vendor.update_attribute :balance, vendor.calculated_balance
    
    first_transfer = vendor.funds_transfers.order('created_at ASC, id ASC').first
    second_transfer = vendor.funds_transfers.order('created_at ASC, id ASC')[1]
    last_transfer = vendor.funds_transfers.order('created_at ASC, id ASC').last
    
    refund = FundsRefund.make! :requested_amount => 70, :vendor=>vendor
    assert refund.execute
    assert_equal'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal [first_transfer, second_transfer], refund.funds_transfers.to_a
    assert_equal [refund], first_transfer.reload.funds_refunds.to_a
    assert_equal [refund], second_transfer.reload.funds_refunds.to_a
    assert_equal 80, refund.amount_available_for_refund
    assert_equal 80, refund.vendor.reload.balance
    assert_equal 50, first_transfer.reload.refunded_amount
    assert_equal 20, second_transfer.reload.refunded_amount
    
    refund2 = FundsRefund.make! :requested_amount => 70, :vendor=>vendor
    assert refund2.execute
    assert_equal'complete', refund2.status
    assert_equal refund2.requested_amount, refund2.refunded_amount
    assert_equal [second_transfer, last_transfer], refund2.funds_transfers
    assert_equal [refund], first_transfer.reload.funds_refunds.to_a
    assert_equal [refund, refund2], second_transfer.reload.funds_refunds.to_a
    assert_equal [refund2], last_transfer.reload.funds_refunds.to_a
    assert_equal 10, refund2.amount_available_for_refund
    assert_equal 10, refund2.vendor.reload.balance
    assert_equal 50, second_transfer.reload.refunded_amount
    assert_equal 40, last_transfer.reload.refunded_amount
    
    refund3 = FundsRefund.make! :requested_amount => 10, :vendor=>vendor
    assert refund3.execute
    assert_equal'complete', refund3.status
    assert_equal refund3.requested_amount, refund3.refunded_amount
    assert_equal [last_transfer], refund3.funds_transfers
    assert_equal [refund], first_transfer.reload.funds_refunds.to_a
    assert_equal [refund, refund2], second_transfer.reload.funds_refunds.to_a
    assert_equal [refund2, refund3], last_transfer.reload.funds_refunds.to_a
    assert_equal 50, last_transfer.refunded_amount
    assert_equal 0, refund3.amount_available_for_refund
    assert_equal 0, refund3.vendor.reload.balance
  end
  
  test "fail to refund when transfers are too old" do
    transfer = FundsTransfer.make!(:successful, :created_at => Time.now - FundsRefund::REFUND_POSSIBLE_FOR - 1.day)
    VendorTransaction.create_for transfer
    transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    invalid = FundsRefund.make :vendor=>transfer.vendor.reload

    assert !invalid.save
  end
  
  test "skip old transfers when withdrawing" do
    vendor = Vendor.make!
    transfer_old = FundsTransfer.make!(:successful, :amount=>50, :vendor=>vendor, :created_at => Time.now - FundsRefund::REFUND_POSSIBLE_FOR - 1.day)
    VendorTransaction.create_for transfer_old
    transfer_old.transactions.create!(:action => "purchase", :amount => transfer_old.amount_in_cents, :response => ResponseStruct.new)
    
    transfer = FundsTransfer.make!(:successful, :amount=>50, :vendor=>vendor)
    VendorTransaction.create_for transfer
    transfer.transactions.create!(:action => "purchase", :amount => transfer.amount_in_cents, :response => ResponseStruct.new)
    
    refund = FundsRefund.make! :requested_amount => 40, :vendor=>vendor
    
    assert_equal 50, refund.amount_available_for_refund
    assert refund.execute
    assert_equal 'complete', refund.status
    assert_equal refund.requested_amount, refund.refunded_amount
    assert_equal [transfer.reload], refund.funds_transfers.to_a
    assert_equal 0, transfer_old.reload.refunded_amount.to_i
    assert_equal 40, transfer.reload.refunded_amount.to_i
    assert_equal 10, refund.amount_available_for_refund
    assert_equal 60, refund.vendor.reload.balance
    
    refund2 = FundsRefund.make! :requested_amount => 10, :vendor=>vendor
    
    assert refund2.execute
    assert_equal'complete', refund2.status
    assert_equal refund2.requested_amount, refund2.refunded_amount
    assert_equal [transfer], refund2.funds_transfers.to_a
    assert_equal [refund, refund2], transfer.reload.funds_refunds.to_a
    assert_equal 0, transfer_old.refunded_amount.to_i
    assert_equal 50, transfer.refunded_amount
    assert_equal 0, refund.amount_available_for_refund
    assert_equal 50, refund.vendor.reload.balance
  end
  
  test "refund too much" do
    invalid = FundsRefund.make :requested_amount => 1000
    assert !invalid.save
  end
  
  test 'cant refund when there were no transfers' do
    #deafult vendor has no transfers
    invalid = FundsRefund.make :vendor=>Vendor.make!
    assert !invalid.save
  end
  
  test "execute fails without transactions" do
    refund = FundsRefund.make!
    assert !refund.execute
  end
  
end
