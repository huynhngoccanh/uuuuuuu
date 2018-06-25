require 'test_helper'

class CjOfferTest < ActiveSupport::TestCase
  test "make" do
    cj_offer = CjOffer.make
    assert cj_offer.save
  end
end
