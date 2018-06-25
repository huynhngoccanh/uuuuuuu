class Search::IntentOutcome < ActiveRecord::Base
  belongs_to :intent

  validates :intent_id, :presence=>true

  validates :purchase_made, :inclusion => { :in => [true, false] }
  validates :merchant_id, :presence => true, :if => Proc.new{|o| o.purchase_made}

  attr_accessible :comment, :purchase_made, :merchant_id

  has_one :user, :through => :intent

  def selected_merchant
    Search::Merchant.find_by_id(merchant_id)
  end

end
