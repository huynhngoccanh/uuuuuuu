class Search::IrMerchant < Search::Merchant
  has_one :commission, :class_name => 'IrCommission'
  belongs_to :advertiser, :class_name => 'IrAdvertiser', :foreign_key => 'db_id'

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  def set_attributes_from_search(advertiser, offer, controller)
    coupons = advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
    coupons_count = coupons.count 
    money = advertiser.max_commission_percent.blank? ? number_to_currency(number_with_precision(advertiser.max_commission_dollars, :precision => 2)) : number_to_percentage(advertiser.max_commission_percent, {:precision => 1, :strip_insignificant_zeros => true})
    self.company_name = advertiser.name
    self.company_address = coupons.push(coupons_count)
    urls = URI.extract(advertiser.advertiser_url)
    self.company_url = URI.parse(urls[0]).host
    self.user_money = "Up to #{money}"
    self.offer_name = offer.blank? ? 'N/A' : offer[:name]
    self.coupon_code = coupons_count == 0 ? 'No coupons' : pluralize(coupons_count, 'coupon')
    self.offer_buy_url = offer.blank? ? advertiser.base_tracking_url : offer[:buy_url]
    add_intent_id_to_trackable_url('subId1')
    self.offer_buy_url = self.offer_buy_url  + "&url=#{URI::encode(urls[0])}"
    self.logo_url = advertiser.logo.url.index('missing.png').nil? ? 'https://ubitru.com' + advertiser.logo.url : nil
    self.company_coupons_url = controller.auction_coupons_url('ir', advertiser.advertiser_id)
  end
end
