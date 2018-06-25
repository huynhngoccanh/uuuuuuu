require 'test_helper'

class AuctionAddressTest < ActiveSupport::TestCase
  test "make" do
    auction_address = AuctionAddress.make
    assert auction_address.save
  end
end
