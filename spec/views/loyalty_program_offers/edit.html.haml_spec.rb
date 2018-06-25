require 'rails_helper'

RSpec.describe "loyalty_program_offers/edit", type: :view do
  before(:each) do
    @loyalty_program_offer = assign(:loyalty_program_offer, LoyaltyProgramOffer.create!(
      :loyalty_program => nil,
      :name => "MyString",
      :coupon_code => "MyString",
      :offer_url => "MyString",
      :offer_description => "MyText",
      :product_offer => false,
      :is_deleted => false
    ))
  end

  it "renders the edit loyalty_program_offer form" do
    render

    assert_select "form[action=?][method=?]", loyalty_program_offer_path(@loyalty_program_offer), "post" do

      assert_select "input#loyalty_program_offer_loyalty_program_id[name=?]", "loyalty_program_offer[loyalty_program_id]"

      assert_select "input#loyalty_program_offer_name[name=?]", "loyalty_program_offer[name]"

      assert_select "input#loyalty_program_offer_coupon_code[name=?]", "loyalty_program_offer[coupon_code]"

      assert_select "input#loyalty_program_offer_offer_url[name=?]", "loyalty_program_offer[offer_url]"

      assert_select "textarea#loyalty_program_offer_offer_description[name=?]", "loyalty_program_offer[offer_description]"

      assert_select "input#loyalty_program_offer_product_offer[name=?]", "loyalty_program_offer[product_offer]"

      assert_select "input#loyalty_program_offer_is_deleted[name=?]", "loyalty_program_offer[is_deleted]"
    end
  end
end
