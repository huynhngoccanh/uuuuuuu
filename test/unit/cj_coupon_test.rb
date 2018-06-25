require 'test_helper'

class CjCouponTest < ActiveSupport::TestCase
  test "make" do
    cj_coupon = CjCoupon.make
    assert cj_coupon.save
  end
end
