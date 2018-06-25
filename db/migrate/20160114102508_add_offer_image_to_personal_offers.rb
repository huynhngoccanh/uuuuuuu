class AddOfferImageToPersonalOffers < ActiveRecord::Migration
  def self.up
   add_attachment :personal_offers, :offer_image
  end

  def self.down
   remove_attachment :personal_offers, :offer_image
  end
end
