class CjCommission < ActiveRecord::Base
  belongs_to :cj_offer
  has_many :muddleme_transactions, :as=>:transactable, :dependent=>:destroy
  serialize :params

  after_create :close_auction_and_pay_commission

  def set_attributes_from_response_row(row) 
    self.price                = row['sale_amount']
    self.commission_amount    = row['commission_amount']
    self.auction_id_received  = row['sid']
    self.occurred_at          = row['event_date']
    self.commission_id        = row['commission_id']
    self.params               = row
    self.resulting_balance    = SystemStats.system_balance + self.commission_amount

    auction = Auction.find_by_id auction_id_received
    return self if !auction

    cj_offer_found = auction.cj_offers.where(:advertiser_id=>row['cid'], :ad_id=>row['aid']).first
    return self if !cj_offer_found

    self.cj_offer = cj_offer_found
    cj_offer_found.commission_value = commission_amount
    cj_offer_found.commission_payed = true
    cj_offer.save
    
    self
  end

  def self.fetch_new_commissions
    response = CJ.commission_details
    return unless response['commissions'] && response['commissions']['commission']
    commissions = response['commissions']['commission']
    commissions = [commissions] if !commissions.is_a? Array
    commissions.each do |row|
      next if self.find_by_commission_id row['commission_id']
      self.new.set_attributes_from_response_row(row).save!
    end
  end

  def advertiser
    cj_offer && cj_offer.advertiser
  end

private

  def close_auction_and_pay_commission
    return if !cj_offer || !cj_offer.auction
    auction = cj_offer.auction
    auction.confirm_from_affiliate_offer cj_offer
  end
end
