class AvantOffer < ActiveRecord::Base
  belongs_to :auction
  serialize :params
  has_one :commission, :class_name=>'AvantCommission'
  belongs_to :advertiser, -> {where(:inactive=>[nil,0])}, :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', 
              :class_name=>'AvantAdvertiser'

  def set_attributes_from_response_row(row) 
    self.name             = row['Product_Name']
    self.advertiser_name  = row['Merchant_Name']
    self.advertiser_id    = row['Merchant_Id']
    self.price            = row['Retail_Price']
    self.buy_url          = row['Buy_URL']
    self.commission_percent = row['Commission'].gsub('%','').to_f if row['Commission'].match('\%')
    self.commission_dollars = row['Commission'].gsub('$','').to_f if row['Commission'].match('\$')
    self.params           = row
    self
  end

  def self.fetch_offer_by_name_for_advertiser name, advertiser_id, link_tracking_code = 'registration'
    return nil if advertiser_id.blank?

    response = Avant.product_search name, link_tracking_code, 1, [advertiser_id]

    result = nil
    response.to_a.each do |row|
      if row['Merchant_Id'] == advertiser_id
         result = self.new.set_attributes_from_response_row(row)
       end
    end
    result
  end

  def self.fetch_offers_from_only_cat_associated_advertisers name, product_category, link_tracking_code = 'registration', max_offers = 8
    num_products_to_offer = 8

    search_limit = max_offers
    #go through each category mapping level for advertiser
    #collect advertisers fro each category level mappings
    parent_category = product_category.parent
    product_category_levels = [product_category, parent_category, parent_category.parent]
    advertiser_tiers = []
    product_category_levels.each do |cat|
      advertiser_tiers << cat.avant_preferred_advertisers - advertiser_tiers.flatten
    end
    product_category_levels.each do |cat|
      advertiser_tiers << cat.avant_non_preferred_advertisers - advertiser_tiers.flatten
    end

    search_limit = advertiser_tiers.count{|t| !t.blank?} * max_offers
    search_limit = [search_limit, max_offers].max

    limit_advertisers = advertiser_tiers.flatten.uniq.map(&:advertiser_id)

    return [] if limit_advertisers.blank?

    response = Avant.product_search name, link_tracking_code, search_limit, limit_advertisers

    result = []
    advertiser_tiers.each do |tier|
      next if tier.blank?
      #search through response and add proper results
      tier.each do |advertiser|
        found = []
        response.to_a.each do |row|
          if row['Merchant_Id'] == advertiser.advertiser_id
            result << self.new.set_attributes_from_response_row(row)
          end
          break if result.length == max_offers
        end
        result + found
      end
      break if result.length == max_offers
    end
    result
  end

  def self.fetch_offers name, product_category, link_tracking_code = 'registration', max_offers = 8
    num_products_to_offer = 8

    search_limit = max_offers
    #go through each category mapping level for advertiser
    #collect advertisers fro each category level mappings
    parent_category = product_category.parent
    product_category_levels = [product_category, parent_category, parent_category.parent]
    advertiser_tiers = []
    product_category_levels.each do |cat|
      advertiser_tiers << cat.avant_preferred_advertisers - advertiser_tiers.flatten
    end
    product_category_levels.each do |cat|
      advertiser_tiers << cat.avant_non_preferred_advertisers - advertiser_tiers.flatten
    end

    search_limit = advertiser_tiers.count{|t| !t.blank?} * max_offers
    search_limit = [search_limit, max_offers].max

    limit_advertisers = advertiser_tiers.flatten.uniq.map(&:advertiser_id)

    response = Avant.product_search name, link_tracking_code, search_limit, limit_advertisers

    if limit_advertisers.blank?
      result = response.to_a.map{|row| self.new.set_attributes_from_response_row(row)}
      return result  #if no mappings just return what was found
    end

    result = []
    advertiser_tiers.each do |tier|
      next if tier.blank?
      #search through response and add proper results
      tier.each do |advertiser|
        found = []
        response.to_a.each do |row|
          if row['Merchant_Id'] == advertiser.advertiser_id
            result << self.new.set_attributes_from_response_row(row)
          end
          break if result.length == max_offers
        end
        result + found
      end
      break if result.length == max_offers
    end
    
    #fill the results with other advertisers
    if result.length < max_offers
      response = Avant.product_search name, link_tracking_code, max_offers + result.length
      response.to_a.each do |row|
        if !limit_advertisers.include?(row['Merchant_Id'])
          result << self.new.set_attributes_from_response_row(row)
          break if result.length == max_offers
        end
      end
    end
    result
  end

  def self.fetch_offers_for_auction auction
    return unless auction.product_auction
    auction.avant_offers.delete_all

    num_products_to_offer = 8

    offers = self.fetch_offers auction.name, auction.product_category, auction.id, num_products_to_offer
    offers.each do |offer|
      offer.auction = auction
      offer.save
    end
    auction.reload
  end  

  def link_html text, cls
    "<a href='#{link_href}' target='_blank' class='#{cls}'>#{text}</a>".html_safe
  end

  def link_href
    buy_url
  end

  def tracking_img
    ''
  end

  def to_api_json
    attrs = [:id, :name, :link_href, :tracking_img]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:advertiser_id] = advertiser.id
    result[:advertiser_name] = advertiser.name
    result[:advertiser_logo_url] = "http://#{HOSTNAME_CONFIG['full_hostname']}#{advertiser.logo.url}",
    result[:advertiser_max_commission_percent] = advertiser.commission_percent
    result[:advertiser_max_commission_dollars] = advertiser.commission_dollars
    result[:advertiser_url] = advertiser.advertiser_url
    result[:coupons_count] = advertiser.coupons.length
    result[:mobile_enabled] = advertiser.mobile_enabled
    result[:provider] = 'avant'
    result
  end

end
