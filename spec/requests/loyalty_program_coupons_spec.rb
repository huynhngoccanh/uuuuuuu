require 'rails_helper'

RSpec.describe "LoyaltyProgramCoupons", type: :request do
  describe "GET /loyalty_program_coupons" do
    it "works! (now write some real specs)" do
      get loyalty_program_coupons_path
      expect(response).to have_http_status(200)
    end
  end
end
