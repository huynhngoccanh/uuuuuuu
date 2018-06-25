require 'rails_helper'

RSpec.describe "loyalty_program_coupons/index", type: :view do
  before(:each) do
    assign(:loyalty_program_coupons, [
      LoyaltyProgramCoupon.create!(
        :loyalty_program => nil,
        :loyalty_program_name => "Loyalty Program Name",
        :header => "Header",
        :ad_id => "Ad",
        :add_url => "Add Url",
        :description => "MyText",
        :code => "Code",
        :manually_uploaded => false
      ),
      LoyaltyProgramCoupon.create!(
        :loyalty_program => nil,
        :loyalty_program_name => "Loyalty Program Name",
        :header => "Header",
        :ad_id => "Ad",
        :add_url => "Add Url",
        :description => "MyText",
        :code => "Code",
        :manually_uploaded => false
      )
    ])
  end

  it "renders a list of loyalty_program_coupons" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Loyalty Program Name".to_s, :count => 2
    assert_select "tr>td", :text => "Header".to_s, :count => 2
    assert_select "tr>td", :text => "Ad".to_s, :count => 2
    assert_select "tr>td", :text => "Add Url".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
