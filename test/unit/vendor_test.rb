require 'test_helper'

class VendorTest < ActiveSupport::TestCase
  test "make" do
    vendor = Vendor.make
    assert vendor.save
  end
end
