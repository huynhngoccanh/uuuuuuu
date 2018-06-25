class AvantCommission < ActiveRecord::Base
  belongs_to :avant_offer
  has_many :muddleme_transactions, :as=>:transactable, :dependent=>:destroy
  serialize :params

  after_create :close_auction_and_pay_commission

  def set_attributes_from_response_row(row) 
    self.price                = row['Transaction_Amount'].gsub('$','').to_f
    self.commission_amount    = row['Total_Commission'].gsub('$','').to_f
    self.auction_id_received  = row['Custom_Tracking_Code']
    self.occurred_at          = row['Transaction_Date']
    self.commission_id        = row['AvantLink_Transaction_Id']
    self.params               = row
    self.resulting_balance    = SystemStats.system_balance + self.commission_amount

    auction = Auction.find_by_id auction_id_received
    return self if !auction

    avant_offer_found = auction.avant_offers.where(:advertiser_id=>row['Merchant_Id']).first
    return self if !avant_offer_found

    self.avant_offer = avant_offer_found
    self
  end

  def self.fetch_new_commissions
    response = Avant.commission_details

    response.to_a.each do |row|
      next if self.find_by_commission_id row['AvantLink_Transaction_Id']
      self.new.set_attributes_from_response_row(row).save!
    end
  end

  def advertiser
    avant_offer && avant_offer.advertiser
  end

  private

  def close_auction_and_pay_commission
    return if !avant_offer || !avant_offer.auction
    auction = avant_offer.auction
    auction.confirm_from_affiliate_offer avant_offer
  end
end
