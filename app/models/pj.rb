class PJ
  include HTTParty

  def self.joined_advertisers page
    params = { :"apiKey"=> $pj_api_key, :"status" => 'joined', :"page"=> page, :"format"=> 'json'}
    self.get($pj_base_url+"/publisher/advertiser?", {:query => params})
  end

  def self.coupons page=1
   # params = { :"apiKey"=> $pj_api_key, :"format"=> 'json', :"startDate" => Date.today.beginning_of_year.strftime("%Y-%m-%d") }
    params = { :"apiKey"=> $pj_api_key, :"format"=> 'json', :"page" => page }
    self.get($pj_base_url+"/publisher/creative/coupon?", {:query => params})
  end

  def self.commission_details
    params = {:"apiKey"    => $pj_api_key,
              :"startDate" => 5.days.ago.to_date.to_s,
              :"endDate"   => Date.today.to_s,
              :"website"   => 'all',
              :"format"    => 'json'}

    self.get($pj_base_url+"/publisher/report/transaction-details?", {:query => params})
  end

  def self.get_product_search_request(product_name, advertiser_id)
    params = {
      :"apiKey"     => $pj_api_key,
      :"programIds" => advertiser_id,
      :"keywords"   => product_name,
      :"format"     => 'json'}

    Typhoeus::Request.new($pj_base_url + '/publisher/creative/product', :method => :get, :params => params)
  end

  def self.set_offer_attributes_from_response_row(row)
    if !row.blank?
      offer_data = {
        :advertiser_id   => row.first['program_id'],
        :advertiser_name => row.first['program_name'],
        :name            => row.first['description_long'],
        :buy_url         => row.first['buy_url']
      }
    end
  end

  def self.request_for_trackable_url advertiser_id
    params = {
      :"apiKey"     => $pj_api_key,
      :"sid"        => advertiser_id,
      :"websiteId"  => $pj_publisher_id,
      :"programId"  => advertiser_id,
      :"format"     => 'json'}
    response = self.get($pj_base_url+"/publisher/creative/generic?", {:query => params})
    response['data'].first['code'] unless response["data"].blank?

  end

end
