require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  class ResponseStruct
    define_method(:success?) { true }
    define_method(:authorization) { '' }
    define_method(:message) { '' }
    define_method(:params) { {'transaction_id'=>'13213123'} }
  end
  
  test "make" do
    o = Campaign.make
    assert o.save
  end
  
  test "to high max bids" do
    campaign = Campaign.make :max_bid=>99999
    assert !campaign.save
  end
  
  test "autobid" do
    #make sure results are consistend
    5.times do
    
      ancestor_category = ProductCategory.make!
      parent_category = ProductCategory.make! :parent=>ancestor_category
      category = ProductCategory.make! :parent=>parent_category

      vendor_with_30_balance = funded_vendor(30)
      vendor_with_35_balance = funded_vendor(35)

      campaign1 = Campaign.make! :max_bid=>10, :product_categories=>[category, ProductCategory.make!]
      campaign2 = Campaign.make! :max_bid=>15, :product_categories=>[ancestor_category]
      campaign3 = Campaign.make! :max_bid=>20, :product_categories=>[ancestor_category, parent_category], :vendor=>vendor_with_30_balance.reload, :budget=>30
      campaign4 = Campaign.make! :max_bid=>25, :product_categories=>[parent_category, ProductCategory.make!], :vendor=>vendor_with_35_balance.reload
      campaign_unmatched = Campaign.make! :max_bid=>25, :product_categories=>[ProductCategory.make!, ProductCategory.make!]

      auction = Auction.make! :product_category=>category, :max_vendors=>2
      assert !auction.bids.map{|b| b.campaign_id}.include?(campaign_unmatched.id)

      assert_equal 4, auction.bids.count
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 16, auction.bids[0].current_value
      assert_equal 16, auction.bids[1].current_value

      #'----- extra bid ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>17, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 5, auction.bids.count
      assert_equal 17, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 18, auction.bids[0].current_value
      assert_equal 18, auction.bids[1].current_value

      #'----- extra bid 2 ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>20, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 6, auction.bids.count
      assert_equal 20, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 20, auction.bids[0].current_value
      assert_equal 20, auction.bids[1].current_value
      assert_equal 20, auction.bids[0].max_value
      assert_equal 20, auction.bids[1].max_value

      #'----- extra bid 3 ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>21, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 7, auction.bids.count
      assert_equal 21, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert auction.bids[0,2].include?(bid) #maybe either of two who bids first is random
      assert_equal 21, auction.bids[0].current_value
      assert_equal 21, auction.bids[1].current_value
      
      assert_equal 35-21, vendor_with_35_balance.funds_refunds.build.amount_available_for_refund
      assert_equal 30, vendor_with_30_balance.balance
      assert_equal 0, vendor_with_30_balance.funds_refunds.build.amount_available_for_refund
      
      refund = FundsRefund.make! :vendor=>vendor_with_35_balance.reload, :requested_amount=>35-21
      refund.execute
      
      auction = Auction.make! :product_category=>category, :max_vendors=>1
      auction = Auction.find auction.id #hard reload
      
      assert_equal 3, auction.bids.count
      assert_equal campaign3, auction.bids.first.campaign
      assert !auction.bids.map{|b| b.campaign}.include?(campaign4) #those campaigns vendors are spent up
      assert_equal 16, auction.bids[0].current_value
      assert_equal 15, auction.bids[1].current_value
      assert_equal 'running', campaign4.reload.status #where not stopping the campaigns if they have no budget limit
      assert_equal 'running', campaign3.reload.status #still enugh to spend
      
      auction.resolve_auction(true, true) #TODO this frees funds for campaign2 but it should the funds should be free when he's not on winners list
      auction.confirm_auction
      auction.accept_auction
      
      auction = Auction.make! :product_category=>category, :max_vendors=>1
      auction = Auction.find auction.id #hard reload
      
      assert_equal 2, auction.bids.count
      assert_equal 11, auction.bids[0].current_value
      assert_equal 10, auction.bids[1].current_value
      assert_equal 11, auction.bids[0].max_value
      assert_equal 10, auction.bids[1].max_value
    end
  end
  
  test "random_winner" do
    emergency_counter = 100
    begin
      category = ProductCategory.make!
      campaign1 = Campaign.make! :max_bid=>10, :product_categories=>[category]
      campaign2 = Campaign.make! :max_bid=>10, :product_categories=>[category]
      auction = Auction.make! :product_category=>category, :max_vendors=>1
    end until emergency_counter < 0 || auction.bids.first.campaign == campaign1
    assert emergency_counter > 0
    
    #reverse
    emergency_counter = 100
    begin
      category = ProductCategory.make!
      campaign1 = Campaign.make! :max_bid=>10, :product_categories=>[category]
      campaign2 = Campaign.make! :max_bid=>10, :product_categories=>[category]
      auction = Auction.make! :product_category=>category, :max_vendors=>1
    end until emergency_counter < 0 || auction.bids.first.campaign == campaign2
    assert emergency_counter > 0
  end
  
    
  
  test 'autobid_by_creating_campaigns' do
    5.times do
      ancestor_category = ProductCategory.make!
      parent_category = ProductCategory.make! :parent=>ancestor_category
      category = ProductCategory.make! :parent=>parent_category

      auction = Auction.make! :product_category=>category, :max_vendors=>2
      
      vendor_with_30_balance = funded_vendor(30)
      vendor_with_35_balance = funded_vendor(35)  

      campaign1 = Campaign.make! :max_bid=>10, :product_categories=>[category, ProductCategory.make!]
      campaign2 = Campaign.make! :max_bid=>15, :product_categories=>[ancestor_category]
      campaign3 = Campaign.make! :max_bid=>20, :product_categories=>[ancestor_category, parent_category], :vendor=>vendor_with_30_balance.reload, :budget=>30
      campaign4 = Campaign.make! :max_bid=>25, :product_categories=>[parent_category, ProductCategory.make!], :vendor=>vendor_with_35_balance.reload
      campaign_unmatched = Campaign.make! :max_bid=>25, :product_categories=>[ProductCategory.make!, ProductCategory.make!]

      auction = Auction.find auction.id #hard reload
      assert !auction.bids.map{|b| b.campaign_id}.include?(campaign_unmatched.id)

      assert_equal 4, auction.bids.count
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 16, auction.bids[0].current_value
      assert_equal 16, auction.bids[1].current_value

      #'----- extra bid ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>17, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 5, auction.bids.count
      assert_equal 17, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 18, auction.bids[0].current_value
      assert_equal 18, auction.bids[1].current_value

      #'----- extra bid 2 ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>20, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 6, auction.bids.count
      assert_equal 20, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign3) #maybe either of two who bids first is random
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert_equal 20, auction.bids[0].current_value
      assert_equal 20, auction.bids[1].current_value
      assert_equal 20, auction.bids[0].max_value
      assert_equal 20, auction.bids[1].max_value

      #'----- extra bid 3 ----'
      auction = Auction.find auction.id #hard reload
      bid = Bid.make!(:max_value=>21, :auction=>auction)
      auction = Auction.find auction.id #hard reload

      assert_equal 7, auction.bids.count
      assert_equal 21, bid.current_value
      assert auction.bids[0,2].map{|b| b.campaign}.include?(campaign4) #maybe either of two who bids first is random
      assert auction.bids[0,2].include?(bid) #maybe either of two who bids first is random
      assert_equal 21, auction.bids[0].current_value
      assert_equal 21, auction.bids[1].current_value
      
      assert_equal 35-21, vendor_with_35_balance.funds_refunds.build.amount_available_for_refund
      assert_equal 30, vendor_with_30_balance.balance
      assert_equal 0, vendor_with_30_balance.funds_refunds.build.amount_available_for_refund
      
      refund = FundsRefund.make! :vendor=>vendor_with_35_balance.reload, :requested_amount=>35-21
      refund.execute
      
      auction = Auction.make! :product_category=>category, :max_vendors=>1
      auction = Auction.find auction.id #hard reload
      
      assert_equal 3, auction.bids.count
      assert_equal campaign3, auction.bids.first.campaign
      assert !auction.bids.map{|b| b.campaign}.include?(campaign4) #those campaigns vendors are spent up
      assert_equal 16, auction.bids[0].current_value
      assert_equal 15, auction.bids[1].current_value
      assert_equal 'running', campaign4.reload.status #where not stopping the campaigns if they have no budget limit
      assert_equal 'running', campaign3.reload.status #still enugh to spend
      
      auction.resolve_auction(true, true) #TODO this frees funds for campaign2 but it should the funds should be free when he's not on winners list
      auction.confirm_auction
      auction.accept_auction
      
      auction = Auction.make! :product_category=>category, :max_vendors=>1
      auction = Auction.find auction.id #hard reload
      
      assert_equal 2, auction.bids.count
      assert_equal 11, auction.bids[0].current_value
      assert_equal 10, auction.bids[1].current_value
      assert_equal 11, auction.bids[0].max_value
      assert_equal 10, auction.bids[1].max_value
    end
  end
  

  test "autobid_after_update" do
    category = ProductCategory.make!

    campaign1 = Campaign.make! :max_bid=>10, :product_categories=>[category]
    campaign2 = Campaign.make! :max_bid=>15, :product_categories=>[category]
    
    auction = Auction.make! :product_category=>category, :max_vendors=>1
    auction = Auction.find auction.id #hard reload
    
    assert_equal 2, auction.bids.count
    assert_equal campaign2, auction.bids.first.campaign
    assert_equal 11, auction.bids[0].current_value
    assert_equal 10, auction.bids[1].current_value
    
    campaign1.update_attributes :max_bid=>16
    auction = Auction.find auction.id #hard reload
    
    assert_equal 2, auction.bids.count
    assert_equal campaign1, auction.bids.first.campaign
    assert_equal 16, auction.bids[0].current_value
    assert_equal 15, auction.bids[1].current_value
  end
end
