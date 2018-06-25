require 'test_helper'

class CjAdvertiserTest < ActiveSupport::TestCase
  test "make" do
    cj_advertiser = CjAdvertiser.make
    assert cj_advertiser.save
  end
end
