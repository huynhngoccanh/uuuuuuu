require 'test_helper'

class ZipCodeTest < ActiveSupport::TestCase
  test "make" do
    zip = ZipCode.make
    assert zip.save
  end
end
