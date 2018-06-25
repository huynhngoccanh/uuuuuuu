require "rails_helper"

RSpec.describe LoyaltyProgramOffersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/loyalty_program_offers").to route_to("loyalty_program_offers#index")
    end

    it "routes to #new" do
      expect(:get => "/loyalty_program_offers/new").to route_to("loyalty_program_offers#new")
    end

    it "routes to #show" do
      expect(:get => "/loyalty_program_offers/1").to route_to("loyalty_program_offers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/loyalty_program_offers/1/edit").to route_to("loyalty_program_offers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/loyalty_program_offers").to route_to("loyalty_program_offers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/loyalty_program_offers/1").to route_to("loyalty_program_offers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/loyalty_program_offers/1").to route_to("loyalty_program_offers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/loyalty_program_offers/1").to route_to("loyalty_program_offers#destroy", :id => "1")
    end

  end
end
