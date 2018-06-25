require 'test_helper'

class AvantOfferTest < ActiveSupport::TestCase
  test "make" do
    avant_offer = AvantOffer.make
    assert avant_offer.save
  end
end
