ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require File.expand_path(File.dirname(__FILE__) + '/blueprints')

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...

  def setup
    Faker::Config.locale = :'en-us'
    seed_email_content
  end

  def seed_email_content
    EmailContent.create(:name=>'auction_initiated_user')
    EmailContent.create(:name=>'auction_ended_user')
    EmailContent.create(:name=>'auction_won_user')
    EmailContent.create(:name=>'auction_won_vendor')
    EmailContent.create(:name=>'first_confirmation_reminder')
    EmailContent.create(:name=>'last_confirmation_reminder')
    EmailContent.create(:name=>'referrals_invite')
    EmailContent.create(:name=>'vendor_confirm_outcome')
    EmailContent.create(:name=>'low_funds_notification_global')
    EmailContent.create(:name=>'low_funds_notification_campaign')
    EmailContent.create(:name=>'recommended_auctions')
    EmailContent.create(:name=>'confirmation_instructions_user')
    EmailContent.create(:name=>'confirmation_instructions_vendor')
    EmailContent.create(:name=>'auction_ended_from_affiliate')
  end

  def funded_vendor amount=nil
    amount ||= 20 + rand(90)
    transfer = FundsTransfer.make!(:successful, :amount=>amount)
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    transfer.vendor
  end

  def fund_vendor vendor, amount
    transfer = FundsTransfer.make!(:successful, :amount=>amount, :vendor=>vendor)
    VendorTransaction.create_for transfer
    TransferFee.create_for transfer
    vendor
  end
end
