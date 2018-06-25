class Admins::StoreCategory < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name
  validates :order, :numericality => { :greater_than_or_equal_to => 0 }, :presence => true
end
