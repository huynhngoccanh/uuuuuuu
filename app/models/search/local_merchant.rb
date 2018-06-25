class Search::LocalMerchant < Search::Merchant
  belongs_to :campaign, :foreign_key => 'db_id'
  belongs_to :offer, :foreign_key => 'other_db_id'

  validates :campaign, :presence => true
  validates :offer, :presence => true

  def set_attributes_from_search(campaign, offer)
    vendor = campaign.vendor
    self.company_name = vendor.company_name
    self.user_money = 1
    self.company_address = vendor.city ? "#{vendor.city} #{vendor.state_abbreviation}" : ''
    self.offer_name = offer.name
    self.coupon_code = offer.coupon_code.blank? ? 'No coupons' : offer.coupon_code
    self.company_phone = vendor.phone.gsub('-', '').gsub(' ', '')
    self.offer_buy_url = offer.product_offer ? offer.offer_url : nil
  end
end
