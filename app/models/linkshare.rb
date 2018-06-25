class Linkshare

  ADVERTISER_STATUSES = {:approved => 'approved'}

  def self.advertisers_by_status(status)
    result = nil
    request = Typhoeus::Request.new("http://lld2.linksynergy.com/services/restLinks/getMerchByAppStatus/#{$linkshare_web_token}/#{URI.escape(status)}", :method => :get)
    request.on_complete do |response|
      if response.success?
        result = Hash.from_xml(response.body)
      end
    end
    request.run
    (result && result['getMerchByAppStatusResponse'] && result['getMerchByAppStatusResponse']['return']) ? result['getMerchByAppStatusResponse']['return'] : []
  end

  def self.get_product_search_request(product_name, advertiser_id)
    params = {
        :token => $linkshare_web_token,
        :keyword => product_name,
        :mid => advertiser_id,
        :max => 1
    }
    Typhoeus::Request.new('http://productsearch.linksynergy.com/productsearch', :method => :get, :params => params)
  end

  def self.commission_details
    result = ''
    params = {
        :nid => 1,
        :token => $linkshare_payment_reports_token,
        :reportid => 12,
        :bdate => 7.days.ago.strftime('%Y%m%d'),
        :edate => Time.now.strftime('%Y%m%d')
    }
    request = Typhoeus::Request.new('https://reportws.linksynergy.com/downloadreport.php', :method => :get, :params => params)
    request.on_complete { |response| result = response.body if (response.success? && response.body != 'No Results Found') }
    request.run
    CSV.parse(result)
  end

  def self.coupons
    result = []
    1.upto(200) do |page|
      request = Typhoeus::Request.new("http://couponfeed.linksynergy.com/coupon?token=#{$linkshare_web_token}&network=1&resultsperpage=500&pagenumber=#{page}", :method => :get)
      response = request.run
      break unless response.success?
      pageresult = Hash.from_xml(response.body)
      break if pageresult.blank? || pageresult['couponfeed'].blank? || pageresult['couponfeed']['link'].blank?
    #  result += pageresult['couponfeed']['link'].map { |link| link unless link['couponcode'].blank? }.compact
       result += pageresult['couponfeed']['link'].map { |link| link }.compact
    end
    result
  end
end