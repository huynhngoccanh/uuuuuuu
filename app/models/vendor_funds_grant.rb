class VendorFundsGrant < ActiveRecord::Base
  belongs_to :vendor
  has_one :vendor_transaction, :as=>:transactable, :dependent=>:destroy
  has_one :muddleme_transaction, :as=>:transactable, :dependent=>:destroy
  validates :vendor, :presence=>true
  validates :vendor_id, :presence=>true
  validates :amount, :numericality=>{:greater_than => 0, :only_integer => true}, :presence=>true

  after_create :update_balances

  attr_accessible :amount

  def update_balances
    MuddlemeTransaction.create_for self
    VendorTransaction.create_for self
  end
end
