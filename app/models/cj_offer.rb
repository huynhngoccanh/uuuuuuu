class CjOffer < ActiveRecord::Base
  belongs_to :auction
  serialize :params
  has_one :commission, :class_name=>'CjCommission'
 belongs_to :advertiser, -> {where({:inactive=>[nil,0]})}, 
    :foreign_key=>'advertiser_id', :primary_key=>'advertiser_id', :class_name=>'CjAdvertiser'
  
  def set_attributes_from_response_row(row) 
    self.name             = row['name']
    self.advertiser_name  = row['advertiser_name']
    self.advertiser_id    = row['advertiser_id']
    self.ad_id            = row['ad_id']
    self.price            = row['price']
    self.buy_url          = row['buy_url']
    self.params           = row
    advertiser = CjAdvertiser.find_by_advertiser_id advertiser_id
    return self if advertiser.blank?
    if (!price || price.to_f.zero?) && 
        (advertiser.commission_dollars && !advertiser.commission_dollars.to_f.zero?)
      self.expected_commission = advertiser.commission_dollars
    else
      self.expected_commission = (price.to_f * (advertiser.commission_percent.to_f/100.0)).round(2)
    end
    self
  end

  def self.product_search name, limit=nil, advertiser_ids=nil, products_per_page=nil
    result = []
    self.product_search_recurse result, name, limit, advertiser_ids, products_per_page
  end

  def self.product_search_recurse result, name, limit, advertiser_ids, products_per_page
    return result if limit && result.length == limit
    return result if !advertiser_ids.blank? && result.length == advertiser_ids.length
    page = 0
    added_some_advertisers = false
    while true do
      page += 1
      limit_advertisers = advertiser_ids.blank? ? [] : advertiser_ids - result.map{|r| r['advertiser_id']}
      response = CJ.product_search name, page, limit_advertisers, products_per_page
      
      break unless response && response['products'] && response['products']['product']
      products = response['products']['product']
      products = [products] if !products.is_a? Array
      products.each do |row|
        if !result.map{|r| r['advertiser_id']}.include? row['advertiser_id']
          result << row
          added_some_advertisers = true
        end
        break if limit && result.length == limit
      end

      break if !advertiser_ids.blank? && result.length == advertiser_ids.length
      break if limit && result.length == limit
      break if (page-1)* CJ::PRODUCTS_PER_PAGE + response['products']['records_returned'].to_i >= response['products']['total_matched'].to_i

      if added_some_advertisers
        return self.product_search_recurse result, name, limit, advertiser_ids, products_per_page
      end
    end 
    result
  end

  def self.fetch_offer_by_name_for_advertiser name, advertiser_id, link_tracking_code = 'registration'
    return nil if advertiser_id.blank?

    response = self.product_search name, 1, [advertiser_id], 1
    result = response.to_a.map{|row| self.new.set_attributes_from_response_row(row)}

    result.blank? ? nil: result[0]
  end

  def self.fetch_offers_from_only_cat_associated_advertisers name, product_category, link_tracking_code = 'registration', max_offers = 8
    parent_category = product_category.parent
    product_category_levels = [product_category, parent_category, parent_category.parent]
    advertiser_tiers = []
    product_category_levels.each do |cat|
      advertiser_tiers << cat.cj_preferred_advertisers - advertiser_tiers.flatten
    end
    product_category_levels.each do |cat|
      advertiser_tiers << cat.cj_non_preferred_advertisers - advertiser_tiers.flatten
    end

    limit_advertisers = advertiser_tiers.flatten.uniq.map(&:advertiser_id)

    return [] if limit_advertisers.blank?

    result = []
    #make request for each tier if needed
    advertiser_tiers.each do |tier|
      next if tier.blank?
      response = self.product_search name, 1, tier.map(&:advertiser_id)
      result += response.to_a.map{|row| self.new.set_attributes_from_response_row(row)}
      break if result.length == max_offers
    end
    result
  end

  #!! duplicated code from avant offer with appropriate adjustments
  def self.fetch_offers name, product_category, link_tracking_code = 'registration', max_offers = 8
    search_limit = max_offers
    #go trouch each category mapping lvel for advertiser
    #collect advertisers fro each category level mappings
    parent_category = product_category.parent
    product_category_levels = [product_category, parent_category, parent_category.parent]
    advertiser_tiers = []
    product_category_levels.each do |cat|
      advertiser_tiers << cat.cj_preferred_advertisers - advertiser_tiers.flatten
    end
    product_category_levels.each do |cat|
      advertiser_tiers << cat.cj_non_preferred_advertisers - advertiser_tiers.flatten
    end

    limit_advertisers = advertiser_tiers.flatten.uniq.map(&:advertiser_id)

    if limit_advertisers.blank?
      response = self.product_search name, search_limit
      result = response.to_a.map{|row| self.new.set_attributes_from_response_row(row)}
      return result  #if no mappings just return what was found
    end

    result = []
    search_limit = max_offers
    #make request for each tier if needed
    advertiser_tiers.each do |tier|
      next if tier.blank?
      response = self.product_search name, search_limit, tier.map(&:advertiser_id)
      result += response.to_a.map{|row| self.new.set_attributes_from_response_row(row)}
      break if result.length == max_offers
      search_limit -= response.length
    end
    
    #fill the results with other advertisers
    if result.length < max_offers
      response = self.product_search name, max_offers + result.length
      response.to_a.each do |row|
        if !limit_advertisers.include?(row['advertiser_id'])
          result << self.new.set_attributes_from_response_row(row)
          break if result.length == max_offers
        end
      end
    end
    result
  end

  def self.fetch_offers_for_auction auction
    return unless auction.product_auction
    auction.cj_offers.delete_all

    num_products_to_offer = 8

    offers = self.fetch_offers auction.name, auction.product_category, auction.id, num_products_to_offer
    offers.each do |offer|
      offer.auction = auction
      offer.save
    end
    auction.reload
  end  

  def link_html text, cls
    "<a href='#{link_href}' target='_blank' class='#{cls}'>#{text}</a>#{tracking_img}".html_safe
  end

  def link_href
    buy_url.gsub(/^(http:\/\/[^\/]+\/click[^\?]+)(\?)/, '\1' + "?sid=#{ auction.blank? ? 'registration' : auction.id }&")
  end

  def tracking_img
    "<img src='#{tracking_img_src}' width='1' height='1'/>".html_safe
  end

  def tracking_img_src
    buy_url.gsub(/(^http:\/\/[^\/]+\/)(click)([^\?]+).*$/,'\1image\3')
  end

  def to_api_json
    attrs = [:id, :name, :link_href, :tracking_img]
    result = attrs.inject({}) {|result, attr| result[attr] = send(attr.to_s); result}
    result[:advertiser_id] = advertiser.id
    result[:advertiser_name] = advertiser.name
    result[:advertiser_logo_url] = "http://#{HOSTNAME_CONFIG['full_hostname']}#{advertiser.logo.url}",
    result[:advertiser_max_commission_percent] = advertiser.max_commission_percent
    result[:advertiser_max_commission_dollars] = advertiser.max_commission_dollars
    result[:advertiser_url] = advertiser.advertiser_url
    result[:coupons_count] = advertiser.coupons.length
    result[:mobile_enabled] = advertiser.mobile_enabled
    result[:provider] = 'cj'
    result
  end
end
