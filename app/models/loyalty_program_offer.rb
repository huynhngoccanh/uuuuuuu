class LoyaltyProgramOffer < ActiveRecord::Base
  include Offerable
  acts_as_paranoid
  
  belongs_to :loyalty_program
  
  has_many :offer_images, class_name: LoyaltyProgramOfferImage.name, :dependent=>:destroy
  
end
