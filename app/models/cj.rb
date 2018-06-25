class CJ
  include HTTParty
  base_uri 'https://api.cj.com'

  headers 'authorization' => $cj_api_key
  WEBSITE_ID = $cj_website_id

  PER_PAGE = 100
  PRODUCTS_PER_PAGE = 100

  KNOWN_TRACKING_DOMAINS = %w(www.anrdoezrs.net www.dpbolvw.net www.tkqlhce.com www.jdoqocy.com www.kqzyfj.com www.awltovhc.com)

  # !!! TODO intercept 500 errors (link_types producees it i think)

  def self.product_search product_name, page=1, advertiser_ids=nil, product_per_page=nil
    params = {
      :"website-id" => WEBSITE_ID,
      :"records-per-page" => product_per_page || PRODUCTS_PER_PAGE,
      :"page-number" => page,
      :"advertiser-ids" => 'joined',
      :keywords => product_name,
    }
    params[:"advertiser-ids"] = advertiser_ids.join(',') unless advertiser_ids.blank?

    check_result(self.get("/v2/product-search", {:query => params}))
  end

  def self.get_product_search_request(product_name, advertiser_id)
    params = {
        :"website-id" => WEBSITE_ID,
        :"records-per-page" => 1,
        :"page-number" => 1,
        :"advertiser-ids" => advertiser_id,
        :keywords => product_name,
    }
    Typhoeus::Request.new(self.base_uri + '/v2/product-search', :method => :get, :params => params, :headers => self.headers)
  end

  def self.commission_details
    params = {
      :"date-type"=>'event',
      :"start-date"=>5.days.ago.to_date.to_s,
      :"end-date"=>Date.today.to_s,
    }
    check_result(self.get('/v3/commissions', {:query => params}))
  end

  def self.categories
    self.get('/categories')
  end

  def self.link_types
    self.get('/link-types')
  end

  def self.joined_advertisers page=1
    params = {
        :"page-number" => page,
        :"records-per-page" => PER_PAGE,
        :"advertiser-ids" => 'joined',
    }
    check_result(self.get('/v3/advertiser-lookup', {:query => params}))
  end

  def self.coupons page=1, advertiser_ids='joined'
    params = {
      :"website-id" => WEBSITE_ID,
      :"records-per-page" => PER_PAGE,
      :"page-number" => page,
      :"advertiser-ids" => advertiser_ids,
      :"promotion-type" => 'coupon',
    }

    check_result(self.get("/v2/link-search", {:query => params}))
  end

  def self.request_for_trackable_url(advertiser_id)
    params = {
        :'website-id' => WEBSITE_ID,
        :'records-per-page' => 1,
        :'page-number' => 1,
        :'advertiser-ids' => advertiser_id
    }
    Typhoeus::Request.new(self.base_uri + '/v2/link-search', :method => :get, :params => params, :headers => self.headers)
  end

  def self.check_result result
    return nil if !result['cj_api']
    result['cj_api']
  end

  def self.tracking_domain
    KNOWN_TRACKING_DOMAINS[Time.now.to_i % KNOWN_TRACKING_DOMAINS.length]
  end

end
