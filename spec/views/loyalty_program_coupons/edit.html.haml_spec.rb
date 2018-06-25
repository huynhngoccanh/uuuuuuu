require 'rails_helper'

RSpec.describe "loyalty_program_coupons/edit", type: :view do
  before(:each) do
    @loyalty_program_coupon = assign(:loyalty_program_coupon, LoyaltyProgramCoupon.create!(
      :loyalty_program => nil,
      :loyalty_program_name => "MyString",
      :header => "MyString",
      :ad_id => "MyString",
      :add_url => "MyString",
      :description => "MyText",
      :code => "MyString",
      :manually_uploaded => false
    ))
  end

  it "renders the edit loyalty_program_coupon form" do
    render

    assert_select "form[action=?][method=?]", loyalty_program_coupon_path(@loyalty_program_coupon), "post" do

      assert_select "input#loyalty_program_coupon_loyalty_program_id[name=?]", "loyalty_program_coupon[loyalty_program_id]"

      assert_select "input#loyalty_program_coupon_loyalty_program_name[name=?]", "loyalty_program_coupon[loyalty_program_name]"

      assert_select "input#loyalty_program_coupon_header[name=?]", "loyalty_program_coupon[header]"

      assert_select "input#loyalty_program_coupon_ad_id[name=?]", "loyalty_program_coupon[ad_id]"

      assert_select "input#loyalty_program_coupon_add_url[name=?]", "loyalty_program_coupon[add_url]"

      assert_select "textarea#loyalty_program_coupon_description[name=?]", "loyalty_program_coupon[description]"

      assert_select "input#loyalty_program_coupon_code[name=?]", "loyalty_program_coupon[code]"

      assert_select "input#loyalty_program_coupon_manually_uploaded[name=?]", "loyalty_program_coupon[manually_uploaded]"
    end
  end
end
