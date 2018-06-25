require 'test_helper'

class BidTest < ActiveSupport::TestCase
  test "make" do
    o = Bid.make
    assert o.save
  end
  
  test "current values" do
    auction = Auction.make! :max_vendors=>2
    bid = Bid.make! :auction=>auction, :max_value=>10, :created_at=>Time.now-3.second, :updated_at=>Time.now-3.second
    bid.reload
    assert_equal bid.minimum_value, bid.current_value
    
    bid2 = Bid.make! :auction=>auction, :max_value => 12, :created_at=>Time.now-2.second, :updated_at=>Time.now-2.second
    bid.reload; bid2.reload
    assert_equal bid.minimum_value, bid.current_value 
    assert_equal bid.minimum_value, bid2.current_value
    
    invalid_bid = Bid.make :auction=>auction, :max_value => 8
    assert invalid_bid.save #CAN bid lowe than current max
    
    bid3 = Bid.make! :auction=>auction, :max_value => 12, :created_at=>Time.now-1.seconds, :updated_at=>Time.now-1.seconds
    bid.reload; bid2.reload; bid3.reload
    assert_equal 10, bid.current_value
    assert_equal 11, bid2.current_value
    assert_equal 11, bid3.current_value
    
    bid.max_value = 12
    assert bid.save!
    bid.reload; bid2.reload; bid3.reload
    assert_equal 12, bid2.current_value
    assert_equal 12, bid3.current_value
    auction.bids.reload
    assert_equal bid2, auction.bids[0]
    assert_equal bid3, auction.bids[1]
    
    bid.max_value = 13
    bid.save
    bid.reload; bid2.reload; bid3.reload
    
    assert_equal 12, bid.current_value
    assert_equal 12, bid2.current_value
    assert_equal 12, bid3.current_value
  end
  
  test "cant bid with no balance" do
    #deafult vendor has funds transfered
    invalid = Bid.make :vendor=>Vendor.make!, :max_value=>Auction.new.bid_minimum_value
    assert !invalid.save
  end
  
  test "cant bid more than balance" do
    vendor = funded_vendor
    invalid = Bid.make :vendor=>vendor, :max_value=>vendor.reload.balance.to_i + 1
    assert !invalid.save
    valid = Bid.make :vendor=>vendor, :max_value=>vendor.reload.balance.to_i
    assert valid.save
  end
  
end
