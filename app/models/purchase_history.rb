class PurchaseHistory < ActiveRecord::Base
  belongs_to :loyalty_programs_user
  has_many :items, dependent: :destroy
end
