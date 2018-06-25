class Search::Merchant < ActiveRecord::Base
  USER_MONEY_RATIO = 0.7

  belongs_to :intent
  serialize :params
  attr_accessor :coupons_count
  
  def add_intent_id_to_trackable_url(param_name)
    if self.offer_buy_url
      uri = Addressable::URI.parse(self.offer_buy_url)
      params = uri.query_values || {}
      params[param_name] = intent.nil? ? 0 : intent.id
      uri.query_values = params
      self.offer_buy_url = uri.to_s
    else
      self.offer_buy_url = '/404.html'
    end
  end

  def type_humanized
    case type
      when Search::LocalMerchant.name then 'Muddleme'
      when Search::SoleoMerchant.name then 'Soleo'
      when Search::CjMerchant.name then 'Cj'
      when Search::AvantMerchant.name then 'Avant'
      when Search::PjMerchant.name then 'Pj'
      when Search::IrMerchant.name then 'Ir'
      else 'Linkshare'
    end
  end
end
