class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  before_filter :redirect_tmp
  before_filter :unconfirmed_account_message, :check_if_referred_visit
  before_filter :check_extension_usage
  require 'will_paginate/array'
  before_action :configure_permitted_parameters, if: :devise_controller?  
  #self.per_page = 10

  # protect_from_forgery



  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :zip_code, :email, :password) }
  end


  def api_exception_handler(exception)
    @errors = []
    @errors << exception.message
    @response[:code] = 0
  end

  def required_params_present?(params, * parameters)
    parameters.each do |param|
      if params[param].blank?
        @response[:code] = 0
        @errors << "#{param.to_s} cannot be left blank"
      end
    end
    @errors.blank? ? true : false
  end

  protected :configure_permitted_parameters
  
  def check_extension_usage
    session[:extension_origin] = params[:extension_origin] if params[:extension_origin]
  end

  def redirect_tmp
    if current_admin && current_admin.email == 'admin2@muddleme.com'
      if params[:controller] && params[:controller] != 'admins/affiliated_advertisers' && params[:controller] != 'admins/devise/sessions'
        redirect_to '/admin/affiliated_advertisers/affiliates_categories'
      end
    end
  end


  def get_product_categories(cname)
    ProductCategory.where("name LIKE ?", "#{cname}")
  end

  # def search_soleo_and_local_merchants_db(search, search_intent, zip_code)
  #   result = []
  #   hydra = Typhoeus::Hydra.hydra
  #   soleo_category = SoleoCategory.relevant_search search
  #   soleo_max_money = 0
  #   if soleo_category.present? && soleo_category.parent.present? && soleo_category.parent.parent.present?
  #     soleo_category_search = soleo_category.parent.parent.name
  #     session[:soleo_category_search] = soleo_category_search
  #     # ======================= Soleo prepare XML =======================
  #     builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
  #       xml.request('client-tracking-id' => search_intent.id, :xmlns => 'http://soleosearch.flexiq.soleo.com') {
  #         xml.send('pay-per-call') {
  #           {'business-name' => nil, :zip => zip_code, 'category-name' => soleo_category_search, 'auto-decode' => false, 'result-size' => 12, 'sort-by' => 'value'}.each { |k, v| xml.send(k, v) }
  #         }
  #       }
  #     end
  #
  #     # ======================= Soleo run request =======================
  #     t_request = Typhoeus::Request.new('https://mobapi.soleocom.com/xapi/query', :method => :post, :userpwd => $soleo_basic_auth, :body => builder.to_xml)
  #     t_request.on_complete do |response|
  #       if response.success?
  #         body = Hash.from_xml(response.body)['response']
  #         logger.info "******* #{Time.now.in_time_zone('Eastern Time (US & Canada)').strftime('%m-%d-%y %I-%M-%S %p')} : Soleo listings for #{search} : "
  #         logger.info '******* ' + response.body.to_s
  #         if body['pay_per_call']['available_listings'] != '0'
  #           position = 0
  #           listings = body['pay_per_call']['listings']['listing'].is_a?(Array) ? body['pay_per_call']['listings']['listing'] : [body['pay_per_call']['listings']['listing']]
  #           Search::SoleoMerchant.transaction do
  #             listings.each do |listing|
  #               position += 1
  #               current_money = (listing['ppc_details'] && listing['ppc_details']['listing_price'] && listing['ppc_details']['listing_price'].to_f > 0) ? listing['ppc_details']['listing_price'].to_f : 0
  #               next if current_money < (0.5 / Search::Merchant::USER_MONEY_RATIO)
  #               soleo_max_money = current_money if current_money > soleo_max_money
  #               merchant = Search::SoleoMerchant.new
  #               merchant.intent = search_intent
  #               merchant.set_attributes_from_search listing, position
  #               result << merchant.attributes if merchant.save!
  #             end
  #             soleo_max_money = soleo_max_money * Search::SoleoMerchant::SOLEO_SHARE
  #           end
  #           search_intent.delay(:run_at => Time.now + Search::SoleoMerchant::CALLBACK_DELAY.seconds).send_soleo_callback
  #         end
  #       end
  #     end
  #     selected_merchant_id = search_intent.intent_outcome.nil? ? 0 : search_intent.intent_outcome.merchant_id
  #     search_intent.merchants.where(:type => Search::SoleoMerchant.name).where(:active => false).where('id != ?', selected_merchant_id).delete_all
  #     t_request.run
  #   end
  #
  #   # ======================= Load local merchants =======================
  #   campaigns = Campaign.search_by_category_name(search).all
  #   Search::LocalMerchant.transaction do
  #     campaigns.each do |campaign|
  #       offer = campaign.offer
  #       next if offer.nil?
  #       # check zip codes
  #       if current_user.present?
  #         next if current_user.zip_code.present? && !campaign.zip_codes.blank? && campaign.zip_codes.index { |code| code.code == current_user.zip_code }.nil?
  #       else
  #         next if !campaign.zip_codes.blank? && campaign.zip_codes.index { |code| code.code == zip_code }.nil?
  #       end
  #
  #       # check offer expiration
  #       next if offer.expiration_time.present? && offer.expiration_time.past?
  #       merchant = Search::LocalMerchant.find_or_initialize_by_db_id_and_other_db_id_and_intent_id(campaign.id, offer.id, search_intent.id)
  #       merchant.set_attributes_from_search campaign, offer
  #       if campaign.fixed_bid.nil?
  #         min = campaign.min_bid || Campaign::MIN_BID
  #         max = campaign.max_bid || campaign.budget || min || Campaign::MIN_BUDGET
  #         if soleo_max_money == 0
  #           merchant.user_money = min * Search::Merchant::USER_MONEY_RATIO
  #         else
  #           merchant.user_money = [max, soleo_max_money + 1 < min ? min : soleo_max_money + 1].min * Search::Merchant::USER_MONEY_RATIO
  #         end
  #       else
  #         merchant.user_money = campaign.fixed_bid * Search::Merchant::USER_MONEY_RATIO
  #       end
  #       if merchant.save!
  #         merchant_hash = merchant.attributes
  #         vendor = campaign.vendor
  #         merchant_hash['merchant_email'] = vendor.email
  #         merchant_hash['merchant_review_url'] = vendor.review_url
  #         if merchant_hash['merchant_review_url'].present? && merchant_hash['merchant_review_url'].index('http://').nil? && merchant_hash['merchant_review_url'].index('https://').nil?
  #           merchant_hash['merchant_review_url'] = 'http://' + merchant_hash['merchant_review_url']
  #         end
  #         merchant_hash['offer_expired_at'] = offer.expiration_time.to_date.strftime('%m/%d/%Y') if offer.expiration_time
  #         merchant_hash['offer_service_url'] = offer.offer_url
  #         if merchant_hash['offer_service_url'].present? && merchant_hash['offer_service_url'].index('http://').nil? && merchant_hash['offer_service_url'].index('https://').nil?
  #           merchant_hash['offer_service_url'] = 'http://' + merchant_hash['offer_service_url']
  #         end
  #         merchant_hash['offer_info'] = offer.offer_description
  #         result << merchant_hash
  #       end
  #     end
  #   end
  #   result
  # end



  def experience

  end

  def referral

  end

  def mm_extension
    agent = UserAgent.parse request.env['HTTP_USER_AGENT']
    case agent.browser
    when 'Safari' then enable_safari
    when 'Internet Explorer' then enable_ie
    when 'Chrome' then redirect_to 'https://chrome.google.com/webstore/detail/muddleme/dofcnpiibckhhhmcbnbmkcjclhfhpaad' and return
    when 'Firefox' then redirect_to 'https://addons.mozilla.org/en-us/firefox/addon/muddleme-firefox-extension/versions/?page=1#version-1.1.1' and return
    else raise ActionController::RoutingError.new('Not Found')
    end
  end

  def mm_extension_lite
    agent = UserAgent.parse request.env['HTTP_USER_AGENT']
    case agent.browser
    when 'Safari' then enable_safari_lite
    when 'Internet Explorer' then enable_ie
    when 'Chrome' then redirect_to 'https://chrome.google.com/webstore/detail/muddleme-lite/ohlpjdhemmmeojkcdgmcogheabckkkie' and return
    when 'Firefox' then redirect_to 'https://addons.mozilla.org/en-US/firefox/addon/muddleme-lite-extension/versions/?page=1#version-1.0.5' and return
    else raise ActionController::RoutingError.new('Not Found')
    end
  end

  def enable_safari
    @url = 'http://muddleme.com/safari-extension.safariextz'
    render :enable_safari
  end

  def enable_safari_lite
    @url = 'http://muddleme.com/safari-extension-lite.safariextz'
    render :enable_safari
  end

  def enable_ie
    render :enable_ie
  end

  def mm_ie_extension
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'mm-ie-extension.exe')
  end

  def mm_safari_extension
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'safari-extension.safariextz')
  end

  def mm_safari_extension_lite
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'safari-extension-lite.safariextz')
  end

  def mm_safari_extension_plist
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'safari-extension.plist')
  end

  def mm_chrome_extension
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'mm-chrome-extension.crx')
  end

  def mm_firefox_extension
    mm_download_extension Rails.root.join('../../', 'shared', 'extensions', 'mm-firefox-extension.xpi')
  end

  def check_sample_offers
    name = params[:auction][:name]
    product_category = ProductCategory.find(params[:auction][:product_category_id])

    max_offers = 8
    avant_offers = AvantOffer.fetch_offers(name, product_category, 'registration', max_offers)
    cj_offers = CjOffer.fetch_offers(name, product_category, 'registration', max_offers)
    avant_offers_count = [avant_offers.length, 4].min
    cj_offers_count = [cj_offers.length, 4].min
    @combined_affiliate_offers = cj_offers.first(max_offers - avant_offers_count) + avant_offers.first(max_offers - cj_offers_count)
  end

  def check_sample_offers_avant
    name = params[:auction][:name]
    product_category = ProductCategory.find(params[:auction][:product_category_id])

    max_offers = 8
    avant_offers = AvantOffer.fetch_offers(name, product_category, 'registration', max_offers)
    #write just params to session not whole objects so it wont get overflowed
    session[:avant_offers_params] = avant_offers.map do |offer|
      skip_params = ['id','auction_id','params','created_at','updated_at']
      (AvantOffer.attribute_names - skip_params).inject({}){|res,param| res[param]=offer.send(param); res}
    end
    @just_avant_fetched = true
    @combined_affiliate_offers = avant_offers.first(4)
    render 'check_sample_offers'
  end

  def check_sample_offers_cj
    name = params[:name]
    product_category = ProductCategory.find(params[:product_category_id])

    max_offers = 8
    avant_offers = session[:avant_offers_params].map{|params| AvantOffer.new(params)}
    session[:avant_offers_params] = nil
    cj_offers = CjOffer.fetch_offers(name, product_category, 'registration', max_offers)
    avant_offers_count = [avant_offers.length, 4].min
    cj_offers_count = [cj_offers.length, 4].min
    @just_avant_fetched = false
    @combined_affiliate_offers = cj_offers.first(max_offers - avant_offers_count) + avant_offers.first(max_offers - cj_offers_count)
    render 'check_sample_offers'
  end

  def load_product_categories
    unless params[:id].blank?
      categories = ProductCategory.children_of(params[:id]).order('`order` ASC')
    else
      categories = []
    end

    respond_to do |format|
      format.json { render :json => categories.to_json,
        :content_type => 'text/html',
        :layout => false}
    end
  end

  protected

  def layout_by_resource
    if devise_controller? && resource_name == :vendor || !current_vendor.nil?
      "vendors"
    elsif devise_controller? && resource_name == :admin || !current_admin.nil?
      "ubitru_admin"
    else
      nil
    end
  end

  def after_sign_out_path_for(resource_name)
    resource_name == :vendor ? company_path : root_path
  end

  def check_if_referred_visit
    return if current_user || current_vendor || (params[:referring_user_id].blank? && params[:referring_user_id_or_group_name].blank?)

    referring_user = User.find_by_encoded_id(params[:referring_user_id]) if params[:referring_user_id]

    sales_group = nil
    if referring_user.blank?
      sales_group = SalesGroup.find_by_name(params[:referring_user_id_or_group_name])
      referring_user = sales_group.user if sales_group
      referring_user = User.find_by_sales_name(params[:referring_user_id_or_group_name]) if referring_user.blank?
    end

    return if referring_user.blank?

    existing_visit = ReferredVisit.find_by_id(session[:referred_visit_id]) if session[:referred_visit_id]

    if session[:referred_visit_id].blank? || (existing_visit && existing_visit.user_id != referring_user.id) || (existing_visit && sales_group && existing_visit.sales_group_id != sales_group.id) || (existing_visit && sales_group.blank? && existing_visit.sales_group_id)
      visit = referring_user.referred_visits.build
      visit.sales_group = sales_group if sales_group
      visit.save
      session[:referred_visit_id] = visit.id
    end
  end

  def unconfirmed_account_message
    if current_vendor && !current_vendor.confirmed?
      msg = "Your email is unconfirmed. You will need to confirm your email address in order to create campaigns and offers.<br/>"
      msg += "We've sent an email to #{current_vendor.email} with instructions on how to confirm your account.<br/>"
      msg += "Didn't receive confirmation instructions? <a href=\"#{new_vendor_confirmation_path}\" title=\"Confirmation instructions\">Click here</a>."
      msg += '<br/>PLEASE CHECK SPAM FOLDER'
      flash.now[:warning] = msg.html_safe
    end
    if current_user && !current_user.confirmed?
      msg = "Your email is unconfirmed. You will need to confirm your email address in order to withdraw your earnings.<br/>"
      msg += "We've sent an email to #{current_user.email} with instructions on how to confirm your account.<br/>"
      msg += "Didn't receive confirmation instructions? <a href=\"#{new_user_confirmation_path}\" title=\"Confirmation instructions\">Click here</a>."
      msg += '<br/>PLEASE CHECK SPAM FOLDER'
      flash.now[:warning] = msg.html_safe
    end
  end

  def disallow_unconfirmed
    if (current_vendor && !current_vendor.confirmed?) || (current_user && !current_user.confirmed?)
      alert = 'You have to confirm your account first!'
      if request.format.js?
        flash.now[:alert] = alert
        render 'show_flash'
      else
        redirect_to :back, :alert => alert
      end
    end
  end


  def vendor_auction_list per_page, types=[:bid, :recommended, :latest, :finished , :saved, :won]
    sort_by = ['id', 'name', 'max_vendors', 'budget', 'end_time', 'category', 'status',
      'highest_bids_auctions.max_value', 'lowest_bids_auctions.max_value', "vendor_bid", 'vendor_max_bid', 'vendor_won', 'status']

    active_sql = 'auctions.status = "active"'
    not_ended_sql = 'auctions.end_time > ?'
    where_conds = {
      :bid => active_sql,
      :saved =>['auctions_vendors.vendor_id = ?', (current_vendor ? current_vendor.id : nil)],
      :finished => ['auctions.end_time < ?', Time.now],
      :all_unfinished => [not_ended_sql, Time.now],
      :product_unfinished => ["#{not_ended_sql} AND auctions.product_auction = 1", Time.now],
      :service_unfinished => ["#{not_ended_sql} AND auctions.product_auction = 0", Time.now],
      :user => ["#{active_sql} AND user_id = ?", (@auction ? @auction.user.id : (@user ? @user.id : nil))]
    }

    types.each do |type|
      next if type==:recommended && !@auctions_bid.blank? #if no recommnded than fallback to latest
      next if type==:latest && !@auctions_recommended.blank? #if no bid history than fallback to recommnded

      instance_variable_set "@#{type}_order", 'id'
      dir = instance_variable_set "@#{type}_dir", :DESC
      params[:"#{type}_order"] = 'id' if params[:"#{type}_order"].blank?

      if params[:"#{type}_order"] && sort_by.include?(params[:"#{type}_order"])
        instance_variable_set "@#{type}_order", params[:"#{type}_order"]
        instance_variable_set "@#{type}_order_str", 'auctions.id' if params[:"#{type}_order"] == 'id'
        instance_variable_set "@#{type}_order_str", 'auctions.name' if params[:"#{type}_order"] == 'name'
        instance_variable_set "@#{type}_order_str", 'IF(auctions.product_auction, product_categories.name, service_categories.name)' if params[:"#{type}_order"] == 'category'
        #instance_variable_set "@#{type}_order_str", 'categories.name' if params[:"#{type}_order"] == 'result'
      end
      ord = instance_variable_get "@#{type}_order"
      ord_str = instance_variable_get "@#{type}_order_str"
      dir = instance_variable_set "@#{type}_dir", params[:"#{type}_dir"] == 'DESC' ? :DESC : :ASC unless params[:"#{type}_dir"].blank?


      if [:bid, :finished].include?(type)
        list = current_vendor.auctions.where(where_conds[type])
      elsif [:won].include?(type)
        list = current_vendor.won_auctions
      elsif [:recommended].include?(type)
        list = current_vendor.recommended_auctions
      elsif [:latest].include?(type)
        list = current_vendor.latest_auctions
      else
        list = Auction.where(where_conds[type])
      end

      list = list.search(params[:search]) unless params[:search].blank?

      list = list.includes(:service_category, :product_category, :user, :bids, :highest_bid, :lowest_bid, :saved_by_vendors).
        order("#{ord_str || ord} #{dir}")
      if per_page != -1
        list = list.paginate(:page=>params[:"#{type}_page"], :per_page=>per_page)
      end

      instance_variable_set("@auctions_#{type}", list)
    end
  end

  def list_earnings_and_withdrawals(user=current_user)
    @earnings_order = params[:earnings_order] || 'id'
    @earnings_dir = params[:earnings_dir] == 'DESC' ? :DESC : :ASC
    @withdrawals_order = params[:withdrawals_order] || 'id'
    @withdrawals_dir = params[:withdrawals_dir] == 'DESC' ? :DESC : :ASC

    @earnings = user.search_intents.where('status = "confirmed" AND user_earnings > 0').
      order("#{@earnings_order} #{@earnings_dir}").paginate(:page=>params[:earnings_page], :per_page=>5)
    #@earnings = user.auctions.where('status = "accepted" AND user_earnings > 0').
    #    order("#{@earnings_order} #{@earnings_dir}").paginate(:page=>params[:earnings_page], :per_page=>5)
    @withdrawals = user.funds_withdrawals.where(:success => true).
      order("#{@withdrawals_order} #{@withdrawals_dir}").paginate(:page=>params[:withdrawals_page], :per_page=>5)
  end

  def list_transfers_and_refunds(vendor=current_vendor)
    @transfers_order = params[:transfers_order] || 'created_at'
    @transfers_dir = params[:transfers_dir] == 'ASC' ? :ASC : :DESC
    @refunds_order = params[:refunds_order] || 'created_at'
    @refunds_dir = params[:refunds_dir] == 'ASC' ? :ASC : :DESC

    @transfers = VendorTransaction.where(:vendor_id=>vendor.id, :transactable_type=>['FundsTransfer','VendorFundsGrant']).
      order("#{@transfers_order} #{@transfers_dir}").paginate(:page=>params[:transfers_page], :per_page=>5)
    @refunds = vendor.funds_refunds.
      order("#{@refunds_order} #{@refunds_dir}").paginate(:page=>params[:refunds_page], :per_page=>5)
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from ActionController::RoutingError,      :with => :render_404
    rescue_from ActionController::UnknownController, :with => :render_404
#    rescue_from ActionController::UnknownAction,     :with => :render_404
    rescue_from ActiveRecord::RecordNotFound,        :with => :render_404
  end


  private

    

  def mm_download_extension(path)
    raise ActionController::RoutingError.new('Not Found') unless File.exist? path
    send_file path
  end

  def render_404(exception = nil)
    respond_to do |format|
      format.html { render :template => 'errors/error_404', :status => 404 }
      format.json { render :json => { :error => "Not Found", :message => exception.message }.to_json, :status => 404 }
    end
  end



end
