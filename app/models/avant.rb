class Avant
  include HTTParty
  HTTP_BASE_URI = 'http://www.avantlink.com/api.php'
  HTTPS_BASE_URI = 'https://www.avantlink.com/api.php'
  AFFILIATE_ID = $avant_affiliate_id
  WEBSITE_ID = $avant_website_id
  API_KEY = $avant_api_key

  default_params :affiliate_id=>AFFILIATE_ID

  PER_PAGE = 500

  def self.joined_advertisers
    params = {
        :module=>'AssociationFeed',
        :auth_key => API_KEY,
        :association_status => 'active',
    }
    #self.base_uri HTTPS_BASE_URI
    #check_result(self.get("", {:query => params}))
    #"https://www.avantlink.com/api.php?affiliate_id=103761&auth_key=dee3a3408dfedb7bb1457dba680cbbd7&module=AssociationFeed&output=table&association_status=active"
    check_result(HTTParty.get(HTTPS_BASE_URI+"?affiliate_id=#{AFFILIATE_ID}&auth_key=#{API_KEY}&module=AssociationFeed&output=table&association_status=active"))
  end

  def self.product_search product_name, tracking_code, limit=nil, advertiser_ids=nil
    params = {
      :module=>'ProductSearch',
      :website_id => WEBSITE_ID,
      :search_results_merchant_limit => 1,
      :custom_tracking_code => tracking_code,
      :search_term => product_name,
    }
    params[:search_results_count] = limit unless limit.blank?
    params[:merchant_ids] = advertiser_ids.join('|') unless advertiser_ids.blank?
    self.base_uri HTTP_BASE_URI
    check_result(self.get("", {:query => params}))
  end

  def self.get_product_search_request product_name, advertiser_id, search_intent_id
    params = {
        :module=>'ProductSearch',
        :website_id => WEBSITE_ID,
        :search_results_merchant_limit => 1,
        :search_term => product_name,
        :merchant_ids => advertiser_id,
        :custom_tracking_code => search_intent_id,
        :search_results_count => 1,
        :affiliate_id => AFFILIATE_ID
    }
    Typhoeus::Request.new(HTTP_BASE_URI, :method => :get, :params => params, :headers => self.headers)
  end

  def self.commission_details
    params = {
      :module=>'AffiliateReport',
      :website_id => WEBSITE_ID,
      :auth_key => API_KEY,
      :report_id => 8,
      :date_begin => 2.months.ago.strftime('%Y-%m-%d %H:%M:%S'),
      :date_end=> Time.now.strftime('%Y-%m-%d %H:%M:%S')
    }
    self.base_uri HTTPS_BASE_URI
    check_result(self.get("", {:query => params}))
  end

  def self.coupons
    params = {
      :module=>'AdSearch',
      :website_id => WEBSITE_ID,
      :coupons_only => 1,
      :ad_type => 'text'
    }
    self.base_uri HTTP_BASE_URI
    check_result(self.get("", {:query => params}))
  end

  def self.check_result result
    return nil if !result['NewDataSet']
    return nil if !result['NewDataSet']['Table1']
    return [result['NewDataSet']['Table1']] if !result['NewDataSet']['Table1'].is_a? Array
    result['NewDataSet']['Table1']
  end

end
