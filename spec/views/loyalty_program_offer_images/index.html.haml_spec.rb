require 'rails_helper'

RSpec.describe "loyalty_program_offer_images/index", type: :view do
  before(:each) do
    assign(:loyalty_program_offer_images, [
      LoyaltyProgramOfferImage.create!(
        :loyalty_program => nil,
        :loyalty_program_offer => "",
        :image_file_name => "Image File Name",
        :image_content_type => "Image Content Type",
        :image_file_size => 1
      ),
      LoyaltyProgramOfferImage.create!(
        :loyalty_program => nil,
        :loyalty_program_offer => "",
        :image_file_name => "Image File Name",
        :image_content_type => "Image Content Type",
        :image_file_size => 1
      )
    ])
  end

  it "renders a list of loyalty_program_offer_images" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Image File Name".to_s, :count => 2
    assert_select "tr>td", :text => "Image Content Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
