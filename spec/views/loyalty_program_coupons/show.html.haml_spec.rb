require 'rails_helper'

RSpec.describe "loyalty_program_coupons/show", type: :view do
  before(:each) do
    @loyalty_program_coupon = assign(:loyalty_program_coupon, LoyaltyProgramCoupon.create!(
      :loyalty_program => nil,
      :loyalty_program_name => "Loyalty Program Name",
      :header => "Header",
      :ad_id => "Ad",
      :add_url => "Add Url",
      :description => "MyText",
      :code => "Code",
      :manually_uploaded => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Loyalty Program Name/)
    expect(rendered).to match(/Header/)
    expect(rendered).to match(/Ad/)
    expect(rendered).to match(/Add Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/false/)
  end
end
