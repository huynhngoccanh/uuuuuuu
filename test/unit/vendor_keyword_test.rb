require 'test_helper'

class VendorKeywordTest < ActiveSupport::TestCase
  test "make" do
    keyword = VendorKeyword.make
    assert keyword.save
  end
end
