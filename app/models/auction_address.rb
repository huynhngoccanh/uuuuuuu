class AuctionAddress < ActiveRecord::Base
  
  belongs_to :auction
  
  validates :auction, :presence=>true
  validates :first_name, :presence=>true
  validates :last_name, :presence=>true
  validates :address, :presence=>true
  validates :city, :presence=>true
  validates :zip_code, :presence=>true
  
end
