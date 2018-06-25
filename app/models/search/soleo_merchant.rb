class Search::SoleoMerchant < Search::Merchant
  SOLEO_SHARE = 0.5
  CALLBACK_DELAY = 250
  SESSION_WINDOW = 300

  def set_attributes_from_search(listing, position)
    self.company_name = listing['business_name']
    self.user_money = listing['ppc_details']['listing_price'].to_f * USER_MONEY_RATIO * SOLEO_SHARE
    self.company_address = listing['city'] ? "#{listing['city']} #{listing['state']}" : ''
    self.offer_name = 'N/A'
    self.coupon_code = 'N/A'
    self.company_phone = listing['ppc_details']['connect_number']
    self.params ||= {}
    self.params['listing_id'] = listing['listing_id']
    self.params['tracking_url'] = listing['ppc_details']['tracking_url']
    self.params['merchant_number'] = listing['ppc_details']['merchant_number']
    self.params['connect_number'] = listing['ppc_details']['connect_number']
    self.params['position'] = position

    # callback stuff
    self.params['expired_at'] = Time.now + SESSION_WINDOW.seconds
  end
end
