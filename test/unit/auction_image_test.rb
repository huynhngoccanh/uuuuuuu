require 'test_helper'

class AuctionImageTest < ActiveSupport::TestCase
  test "make" do
    auction_image = AuctionImage.make
    assert auction_image.save
  end

  test "full_url_in_to_api_json" do
    auction_image = AuctionImage.make!
    assert auction_image.to_api_json['image_url'].match HOSTNAME_CONFIG['full_hostname']
  end
end
