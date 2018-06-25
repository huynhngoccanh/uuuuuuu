require 'test_helper'

class EmailContentTest < ActiveSupport::TestCase
  test "statics don't throw errors" do
    assert_not_nil EmailContent.auction_initiated_user_mail?
    assert_not_nil EmailContent.auction_ended_user_mail?
    assert_not_nil EmailContent.auction_won_user_mail?
    assert_not_nil EmailContent.auction_won_vendor_mail?
    assert_not_nil EmailContent.first_confirmation_reminder_mail?
    assert_not_nil EmailContent.last_confirmation_reminder_mail?
    assert_not_nil EmailContent.vendor_confirm_outcome_mail?
    assert_not_nil EmailContent.low_funds_notification_global_mail?
    assert_not_nil EmailContent.low_funds_notification_campaign_mail?
    assert_not_nil EmailContent.recommended_auctions_mail?
  end
end
