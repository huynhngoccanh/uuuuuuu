require 'test_helper'

class AvantAdvertiserTest < ActiveSupport::TestCase
  test "make" do
    avant_advertiser = AvantAdvertiser.make
    assert avant_advertiser.save
  end
end
