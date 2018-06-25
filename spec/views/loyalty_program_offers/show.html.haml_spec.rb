require 'rails_helper'

RSpec.describe "loyalty_program_offers/show", type: :view do
  before(:each) do
    @loyalty_program_offer = assign(:loyalty_program_offer, LoyaltyProgramOffer.create!(
      :loyalty_program => nil,
      :name => "Name",
      :coupon_code => "Coupon Code",
      :offer_url => "Offer Url",
      :offer_description => "MyText",
      :product_offer => false,
      :is_deleted => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Coupon Code/)
    expect(rendered).to match(/Offer Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
