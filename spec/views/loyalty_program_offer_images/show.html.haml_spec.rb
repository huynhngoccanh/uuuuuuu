require 'rails_helper'

RSpec.describe "loyalty_program_offer_images/show", type: :view do
  before(:each) do
    @loyalty_program_offer_image = assign(:loyalty_program_offer_image, LoyaltyProgramOfferImage.create!(
      :loyalty_program => nil,
      :loyalty_program_offer => "",
      :image_file_name => "Image File Name",
      :image_content_type => "Image Content Type",
      :image_file_size => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Image File Name/)
    expect(rendered).to match(/Image Content Type/)
    expect(rendered).to match(/1/)
  end
end
