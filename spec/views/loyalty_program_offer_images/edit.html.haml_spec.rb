require 'rails_helper'

RSpec.describe "loyalty_program_offer_images/edit", type: :view do
  before(:each) do
    @loyalty_program_offer_image = assign(:loyalty_program_offer_image, LoyaltyProgramOfferImage.create!(
      :loyalty_program => nil,
      :loyalty_program_offer => "",
      :image_file_name => "MyString",
      :image_content_type => "MyString",
      :image_file_size => 1
    ))
  end

  it "renders the edit loyalty_program_offer_image form" do
    render

    assert_select "form[action=?][method=?]", loyalty_program_offer_image_path(@loyalty_program_offer_image), "post" do

      assert_select "input#loyalty_program_offer_image_loyalty_program_id[name=?]", "loyalty_program_offer_image[loyalty_program_id]"

      assert_select "input#loyalty_program_offer_image_loyalty_program_offer[name=?]", "loyalty_program_offer_image[loyalty_program_offer]"

      assert_select "input#loyalty_program_offer_image_image_file_name[name=?]", "loyalty_program_offer_image[image_file_name]"

      assert_select "input#loyalty_program_offer_image_image_content_type[name=?]", "loyalty_program_offer_image[image_content_type]"

      assert_select "input#loyalty_program_offer_image_image_file_size[name=?]", "loyalty_program_offer_image[image_file_size]"
    end
  end
end
