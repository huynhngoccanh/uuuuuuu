require 'test_helper'

class AuctionTest < ActiveSupport::TestCase
  test "make" do
    o = Auction.make
    assert o.save
  end
  
  test "proper end time" do
    auction = Auction.make!({:duration=> 1})
    assert_equal auction.end_time, auction.created_at + 1.day
  end
  
  test "resolve_auction" do
    auction = Auction.make! :max_vendors=>2
    vendor = funded_vendor(50)
    bid = Bid.make! :auction=>auction, :vendor=>vendor

    result = auction.resolve_auction true, true
    bid.reload
    vendor.reload
    assert bid.is_winning
    assert auction.winning_bids.include? bid
    assert_equal [bid.vendor], result
    assert_equal auction.bid_minimum_value, bid.current_value
    assert_equal 50 - bid.current_value, vendor.available_balance
  end
  
  test "resolve auction 2 max 3 bidders" do
    auction = Auction.make! :max_vendors=>2
    bid = Bid.make! :auction=>auction, :max_value=>10
    bid2 = Bid.make! :auction=>auction, :max_value => 12
    bid3 = Bid.make! :auction=>auction, :max_value => 12
    
    bid_1_initial_balance = bid.vendor.balance
    bid_2_initial_balance = bid2.vendor.balance
    bid_3_initial_balance = bid3.vendor.balance
    
    bid.reload; bid2.reload; bid3.reload
    bid.max_value = 13
    bid.save
    auction.reload
    auction.resolve_auction true
    bid.reload; bid2.reload; bid3.reload;
    assert auction.winning_bids.include? bid
    assert auction.winning_bids.include? bid2
    assert !auction.winning_bids.include?(bid3)
    
    assert_equal 12, bid.current_value
    assert_equal 12, bid2.current_value
    assert_equal 12, bid3.current_value
    
    assert_equal 0, auction.user.balance.to_i
    
    auction.confirm_auction
    auction.accept_auction
    assert_equal (24 * Auction::USER_EARNINGS_SHARE).round, auction.user.balance.round

    assert_equal bid_1_initial_balance - bid.current_value, bid.vendor.balance.to_i
    assert_equal bid_2_initial_balance - bid2.current_value, bid2.vendor.balance.to_i
    assert_equal bid_3_initial_balance, bid3.vendor.balance.to_i
  end
  
  test 'send_low_overall_balance_notification' do
    vendor = funded_vendor(30)
    
    number_of_mails_sent = ActionMailer::Base.deliveries.length
    
    auction = Auction.make! :max_vendors=>1
    bid_value = 30 - FundsTransfer::MIN_AMOUNT
    Bid.make! :auction=>auction, :max_value=>bid_value
    Bid.make! :auction=>auction, :max_value=>bid_value + Auction.new.bid_value_step, :vendor=>vendor
    
    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction
    
    mail = ActionMailer::Base.deliveries.last

    assert mail.to.include?(vendor.email)
    assert mail.html_part.to_s.include?('balance is running low')
    assert mail.text_part.to_s.include?('balance is running low')
    
    number_of_mails_sent_per_auction = ActionMailer::Base.deliveries.length - number_of_mails_sent
    number_of_mails_sent = ActionMailer::Base.deliveries.length
    
    #dont send second time
    auction = Auction.make! :max_vendors=>1
    Bid.make! :auction=>auction, :max_value=>FundsTransfer::MIN_AMOUNT - 2*Auction.new.bid_value_step
    Bid.make! :auction=>auction, :vendor=>vendor, :max_value=>FundsTransfer::MIN_AMOUNT - Auction.new.bid_value_step
    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction
    
    assert_equal number_of_mails_sent + number_of_mails_sent_per_auction - 1, ActionMailer::Base.deliveries.length
    
    #when transfered back the bid amout
    #send second time if below treshold
    
    fund_vendor vendor, 30

    number_of_mails_sent = ActionMailer::Base.deliveries.length
    
    auction = Auction.make! :max_vendors=>1
    bid_value = 30 - FundsTransfer::MIN_AMOUNT
    Bid.make! :auction=>auction, :max_value=>bid_value
    Bid.make! :auction=>auction, :max_value=>bid_value + Auction.new.bid_value_step, :vendor=>vendor.reload
    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction
    
    mail = ActionMailer::Base.deliveries.last
    assert_equal number_of_mails_sent + number_of_mails_sent_per_auction, ActionMailer::Base.deliveries.length
    assert mail.to.include?(vendor.email)
    assert mail.html_part.to_s.include?('balance is running low')
    assert mail.text_part.to_s.include?('balance is running low')
  end
  
  test 'send_low_campaign_buget_notification' do
    vendor = funded_vendor(200)
    
    category = ProductCategory.make!
    campaign = Campaign.make! :max_bid=>25, :product_categories=>[category], :budget=>30, :vendor=>vendor

    number_of_mails_sent = ActionMailer::Base.deliveries.length
    
    auction = Auction.make! :product_category=>category, :max_vendors=>1
    bid_value = 30 - Campaign::MIN_BUDGET
    Bid.make! :auction=>auction, :max_value=>bid_value

    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction
    
    mail = ActionMailer::Base.deliveries.last
    assert mail.to.include?(vendor.email)
    assert mail.html_part.to_s.include?('running low')
    assert mail.text_part.to_s.include?('running low')
    
    number_of_mails_sent_per_auction = ActionMailer::Base.deliveries.length - number_of_mails_sent
    number_of_mails_sent = ActionMailer::Base.deliveries.length
    campaign = campaign.reload
    #dont send second time
    auction = Auction.make! :product_category=>category, :max_vendors=>1
    Bid.make! :auction=>auction.reload, :max_value=>Campaign::MIN_BUDGET - 2*Auction.new.bid_value_step
    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction
    
    assert_equal number_of_mails_sent + number_of_mails_sent_per_auction - 1, ActionMailer::Base.deliveries.length
    #when increased the budget again
    #send second time if below treshold spent
    campaign.update_attributes! :budget=>59, :max_bid=>campaign.max_bid.to_i
    number_of_mails_sent = ActionMailer::Base.deliveries.length
    
    auction = Auction.make! :product_category=>category, :max_vendors=>1
    bid_value = 30 - Campaign::MIN_BUDGET
    Bid.make! :auction=>auction, :max_value=>bid_value
    auction.resolve_auction(true)
    auction.confirm_auction
    auction.accept_auction

    campaign = campaign.reload
    
    mail = ActionMailer::Base.deliveries.last
    assert_equal number_of_mails_sent + number_of_mails_sent_per_auction, ActionMailer::Base.deliveries.length
    assert mail.to.include?(vendor.email)
    assert mail.html_part.to_s.include?('running low')
    assert mail.text_part.to_s.include?('running low')
  end
  
end
