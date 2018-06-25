require 'test_helper'

class VendorTrackingEventTest < ActiveSupport::TestCase
  test "make" do
    event = VendorTrackingEvent.make!
    assert event.save
  end

  test "auto accept auction" do
    auction = VendorTrackingEvent.make!.auction
    assert auction.reload.outcome.vendor_outcomes.first.auto_accepted
  end
end
