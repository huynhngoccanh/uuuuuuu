require "rails_helper"

RSpec.describe LoyaltyProgramOfferImagesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/loyalty_program_offer_images").to route_to("loyalty_program_offer_images#index")
    end

    it "routes to #new" do
      expect(:get => "/loyalty_program_offer_images/new").to route_to("loyalty_program_offer_images#new")
    end

    it "routes to #show" do
      expect(:get => "/loyalty_program_offer_images/1").to route_to("loyalty_program_offer_images#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/loyalty_program_offer_images/1/edit").to route_to("loyalty_program_offer_images#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/loyalty_program_offer_images").to route_to("loyalty_program_offer_images#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/loyalty_program_offer_images/1").to route_to("loyalty_program_offer_images#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/loyalty_program_offer_images/1").to route_to("loyalty_program_offer_images#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/loyalty_program_offer_images/1").to route_to("loyalty_program_offer_images#destroy", :id => "1")
    end

  end
end
