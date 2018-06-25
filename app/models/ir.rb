class IR
  include HTTParty

  def self.joined_advertisers page
    params = { :"page"=> page}
    auth = {:username => $ir_account_sid, :password => $ir_auth_token}
    account_two_auth = {:username => $ir_account_sid_two, :password => $ir_auth_token_two}
    #API request for Impact radius first account for advertiser information.
    response_one = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid}/Campaigns.json?",  {:basic_auth => auth, :query => params})
    #API request for Impact radius second account for advertiser information.
    response_two = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid_two}/Campaigns.json?",  {:basic_auth => account_two_auth, :query => params})
    #Merging advertisers information from both accounts.
    # break if (response_one.nil? && response_two.nil?) || (response_one['Campaigns'].blank? && response_two['Campaigns'].blank?)
    advertisers_list_one = response_one['Campaigns']
    advertisers_list_one = [advertisers_list_one] unless advertisers_list_one.is_a? Array
    advertisers_list_two = response_two['Campaigns']
    advertisers_list_two = [advertisers_list_two] unless advertisers_list_two.is_a? Array
    (advertisers_list_one + advertisers_list_two).compact
  end

  def self.coupons page
    params = { :"page"=> page, :"Type" => "COUPONS"}
    auth = {:username => $ir_account_sid, :password => $ir_auth_token}
    account_two_auth = {:username => $ir_account_sid_two, :password => $ir_auth_token_two}
    #API request for Impact radius first account for coupon information.
  #  response_one = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid}/PromoAds.json?",  {:basic_auth => auth, :query => params})
    #API request for Impact radius second account for coupon information.
  #  response_two = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid_two}/PromoAds.json?",  {:basic_auth => account_two_auth, :query => params})
    
   
   #response_one = self.get("https://IRJ9df9uNHqv121676BbeSNsfRDonsmtX1:fUyqYXHgmakjNSRy4ve3z3x3HPZabghx@api.impactradius.com/Mediapartners/IRJ9df9uNHqv121676BbeSNsfRDonsmtX1/PromoAds.json?params[page]=1&params[Type]=COUPONS")
   #response_two = self.get("https://IRZAMjNsAfH946535bRU6jf36XdsDE7LT1:CCuWjvftfZe6JK7q7BCgwx88MdggZATw@api.impactradius.com/Mediapartners/IRZAMjNsAfH946535bRU6jf36XdsDE7LT1/PromoAds.json?params[page]=1&params[Type]=COUPONS")
   
   response_one = self.get("https://#{$ir_account_sid}:#{$ir_auth_token}@api.impactradius.com/Mediapartners/#{$ir_account_sid}/PromoAds.json?Page=#{page}&PageSize=1000&params[Type]=COUPONS")
   response_two = self.get("https://#{$ir_account_sid_two}:#{$ir_auth_token_two}@api.impactradius.com/Mediapartners/#{$ir_account_sid_two}/PromoAds.json?Page=#{page}&PageSize=1000&params[Type]=COUPONS")
  
    
    # response_two = self.get("#{$ir_account_sid_two}:#{$ir_auth_token_two}@"+$ir_base_url+"/Mediapartners/#{$ir_account_sid_two}/PromoAds.json?",  {:basic_auth => account_two_auth, :query => params})
    
  
    # break if (response_one.nil? && response_two.nil?) || (response_one['PromotionalAds'].blank? && response_two['PromotionalAds'].blank?)
    #Merging coupon information from both accounts.
    coupons_list_one = response_one['PromotionalAds']
    coupons_list_one = [coupons_list_one] unless coupons_list_one.is_a? Array
    coupons_list_two = response_two['PromotionalAds']
    coupons_list_two = [coupons_list_two] unless coupons_list_two.is_a? Array
    (coupons_list_one + coupons_list_two).compact
  end

  def self.commission_details page
    params = {:"page" => page,  :"ActionDateStart" => 5.days.ago.strftime("%Y-%m-%dT%H:%M:%S-08:00"), :"ActionDateEnd" => Date.today.strftime("%Y-%m-%dT%H:%M:%S-08:00") }
    auth = { :username => $ir_account_sid, :password => $ir_auth_token }
    account_two_auth = {:username => $ir_account_sid_two, :password => $ir_auth_token_two}
    #API request for Impact radius first account for commission information.
    response_one = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid}/Actions.json?",  {:basic_auth => auth, :query => params} )
    #API request for Impact radius second account for commission information.
    response_two = self.get($ir_base_url+"/Mediapartners/#{$ir_account_sid_two}/Actions.json?",  {:basic_auth => account_two_auth, :query => params} )
    return unless (response_one['Actions'].blank? && response_two['Actions'].blank?)
    #Merging commission information from both accounts.
    commission_list_one = response_one['Actions']
    commission_list_one = [commission_list_one] unless commission_list_one.is_a? Array
    commission_list_two = response_two['Actions']
    commission_list_two = [commission_list_two] unless commission_list_two.is_a? Array
    (commission_list_one + commission_list_two).compact
  end

  def self.get_product_search_request(product_name, advertiser_id)
    # params = {
    #   :"apiKey"     => $pj_api_key,
    #   :"programIds" => advertiser_id,
    #   :"keywords"   => product_name,
    #   :"format"     => 'json'}
    #
    # Typhoeus::Request.new($pj_base_url + '/publisher/creative/product', :method => :get, :params => params)
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
    response['data'].first['code']
  end

end
