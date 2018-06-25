require 'rails_helper'

RSpec.describe "loyalty_program_offers/index", type: :view do
  before(:each) do
    assign(:loyalty_program_offers, [
      LoyaltyProgramOffer.create!(
        :loyalty_program => nil,
        :name => "Name",
        :coupon_code => "Coupon Code",
        :offer_url => "Offer Url",
        :offer_description => "MyText",
        :product_offer => false,
        :is_deleted => false
      ),
      LoyaltyProgramOffer.create!(
        :loyalty_program => nil,
        :name => "Name",
        :coupon_code => "Coupon Code",
        :offer_url => "Offer Url",
        :offer_description => "MyText",
        :product_offer => false,
        :is_deleted => false
      )
    ])
  end

  it "renders a list of loyalty_program_offers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Coupon Code".to_s, :count => 2
    assert_select "tr>td", :text => "Offer Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
