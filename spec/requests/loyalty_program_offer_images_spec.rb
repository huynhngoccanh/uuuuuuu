require 'rails_helper'

RSpec.describe "LoyaltyProgramOfferImages", type: :request do
  describe "GET /loyalty_program_offer_images" do
    it "works! (now write some real specs)" do
      get loyalty_program_offer_images_path
      expect(response).to have_http_status(200)
    end
  end
end
