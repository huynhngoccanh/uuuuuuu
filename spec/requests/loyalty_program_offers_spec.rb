require 'rails_helper'

RSpec.describe "LoyaltyProgramOffers", type: :request do
  describe "GET /loyalty_program_offers" do
    it "works! (now write some real specs)" do
      get loyalty_program_offers_path
      expect(response).to have_http_status(200)
    end
  end
end
