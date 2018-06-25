require 'test_helper'

class AvantCouponTest < ActiveSupport::TestCase
  test "make" do
    avant_coupon = AvantCoupon.make
    assert avant_coupon.save
  end
end
