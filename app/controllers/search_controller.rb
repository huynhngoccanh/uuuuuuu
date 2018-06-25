class SearchController < ApplicationController
  include SearchHelper
  include Search
  skip_before_filter :verify_authenticity_token
  before_filter :check_user_messages

  NO_SEARCH_TEXT_STUB = '__NO_SEARCH_TEXT__'
  BING_RESULTS_PER_API = 50
  BING_RESULTS_PER_PAGE = 10
  BING_PAGES_DISPLAY_AROUND = (BING_RESULTS_PER_PAGE - 2) / 2
  BING_PAGES_IN_API_RESULTS = BING_RESULTS_PER_API / BING_RESULTS_PER_PAGE
  PREFERRED_ADVERTISER_NAMES = %w(Whirlpool Fanatics Eastern\ Mountain\ Sports REI Denali North\ by\ Northwest O'Neill Backcountry.com Lacrosse.com Soccer.com City\ Sports Moosejaw Newegg.com
                          Bluefly OtterBox Kmart Sears Gap Old\ Navy Banana\ Republic PETCO\ Animal\ Supplies NORDSTROM.com Gaiam TigerDirect Thrifty\ Rent-A-Car\ System,\ Inc. Expedia,\ Inc Travelocity Hotwire\ US Finish\ Line
                          Modells Shoes.com Famous\ Footwear Best\ Buy\ Co,\ Inc. Lumber\ Liquidators Orvis Taylor\ Made\ Golf Sunglass\ Hut\ Affiliate\ Program Staples Athleta Life\ is\ good Walgreens Priceline\ -\ Flights,\ Hotels,\ Cars,\ Vacation\ Packages Virgin\ Atlantic\ Airways
                          Hotels.com Meijer Fathead Canon New\ Balance Overstock.com Oakley GoLite Nomorerack)

  layout 'search'


  def google_search
    @advertisers = []
    favorite_advertisers = current_user.nil? ? nil : current_user.favorite_advertisers.order('created_at asc')
    if favorite_advertisers.blank?
      PREFERRED_ADVERTISER_NAMES.each { |name| @advertisers.push(CjAdvertiser.find_by_name(name) || AvantAdvertiser.find_by_name(name) || LinkshareAdvertiser.find_by_name(name) || PjAdvertiser.find_by_name(name)) }
    else
      favorite_advertisers.each { |favorite_advertiser| @advertisers.push(favorite_advertiser.advertiser) }
    end
  end

  def bing_search
    @page = (params[:page] || 1).to_i
    @pages = @page - BING_PAGES_DISPLAY_AROUND..@page + BING_PAGES_DISPLAY_AROUND
    skip = (((@page - 1) * BING_RESULTS_PER_PAGE) / BING_RESULTS_PER_API).floor * BING_RESULTS_PER_API
    puts 'SKIP:'
    puts skip
    api_results = []

    if params[:search].present?
      search = params[:search].strip
      session[search] ||= {}
      if session[search][skip].nil?
        request = Typhoeus::Request.new('https://api.datamarket.azure.com/Bing/SearchWeb/v1/Composite', :method => :get, :params => {:Query => "'#{search}'", :'$skip' => skip, :'$format' => :json, :Market => "'en-US'"}, :userpwd => $bing_basic_auth, :accept_encoding => 'gzip')
        puts 'Starting request: ' + request.options[:params].inspect
        response = request.run
        if response.success?
          parsed = JSON.parse response.body
          api_results = parsed['d']['results'][0]['Web']
          session[search][skip] = api_results
          session[search]['total_results'] = parsed['d']['results'][0]['WebTotal']
        else
          @response = nil
        end
      else
        api_results = session[search][skip]
      end
    end
    @results = api_results[((@page - 1) % BING_PAGES_IN_API_RESULTS) * BING_RESULTS_PER_PAGE..(@page % BING_PAGES_IN_API_RESULTS == 0 ? BING_PAGES_IN_API_RESULTS : @page % BING_PAGES_IN_API_RESULTS) * BING_RESULTS_PER_PAGE]
  end

  def check_user_messages
    unless current_user.nil?
      cookies[:user_messages_count] = current_user.search_box_messages.count
    end
  end

  def get_user_messages
    render :json => [] and return unless current_user
    Search::AdminPromotionalBoxMessage.delete_all('DATE(created_at) < CURDATE()')
    messages = current_user.search_box_messages.order('created_at desc').to_a.map { |message| {:id => message.id, :message => message.message} }
    render :json => messages
  end

  def remove_user_message
    render :json => false and return if current_user.nil? || params[:id].nil?
    render :json => Search::BoxMessage.find(params[:id]).delete
  end

  def search_lite
    result = []
    render :json => result and return if params[:search].blank?
    search = params[:search].strip

    if current_user.nil?
      if search == NO_SEARCH_TEXT_STUB
        advertisers = []
        PREFERRED_ADVERTISER_NAMES.each { |name| advertisers.push(CjAdvertiser.find_by_name(name) || AvantAdvertiser.find_by_name(name) || LinkshareAdvertiser.find_by_name(name)) }
        advertisers.compact!
        advertisers.each do |advertiser|
          if advertiser.is_a?(CjAdvertiser)
            merchant = Search::CjMerchant.new
          elsif advertiser.is_a?(AvantAdvertiser)
            merchant = Search::AvantMerchant.new
          else
            merchant = Search::LinkshareMerchant.new
          end
          merchant.advertiser = advertiser
          merchant.set_attributes_from_search advertiser, nil, self
          result << merchant.attributes
        end
      end
      render :json => result and return
    end

    advertisers = []
    @favorite_advertisers = current_user.favorite_advertisers.order('created_at asc')
    if @favorite_advertisers.blank? && search == NO_SEARCH_TEXT_STUB
      PREFERRED_ADVERTISER_NAMES.each { |name| advertisers.push(CjAdvertiser.find_by_name(name) || AvantAdvertiser.find_by_name(name) || LinkshareAdvertiser.find_by_name(name)) }
    else
      @favorite_advertisers.each { |favorite_advertiser| advertisers.push(favorite_advertiser.advertiser) }
    end

    advertisers.compact!
    begin
      search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
    rescue ActiveRecord::RecordNotUnique
      render :json => [] and return
    end

    Search::Merchant.transaction do
      advertisers.each do |advertiser|
        if advertiser.is_a?(CjAdvertiser)
          merchant = Search::CjMerchant.where(db_id: advertiser.id, intent_id: search_intent.id).first_or_initialize
        elsif advertiser.is_a?(AvantAdvertiser)
          merchant = Search::AvantMerchant.where(db_id: advertiser.id, intent_id: search_intent.id).first_or_initialize
        else
          merchant = Search::LinkshareMerchant.where(db_id: advertiser.id, intent_id: search_intent.id).first_or_initialize
        end
        merchant.set_attributes_from_search advertiser, nil, self
        result << merchant.attributes if merchant.save!
      end
    end
    render :json => result
  end

  def search
    result = []
    search = params[:search].strip
    render :json => result and return if current_user.nil? || search.blank?

    # rule to redirect all ISBN numbers to one category
    if /\b(?:ISBN(?:: ?| ))?((?:97[89])?\d{9}[\dx])\b/i.match(search)
      search = 'College and University'
    end

    begin
      search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
    rescue ActiveRecord::RecordNotUnique
      render :json => [] and return
    end

    # result = search_soleo_and_local_merchants_db(search, search_intent, current_user.zip_code)

    Rails.logger.debug "\n \n \n LOCAL RESULT:::#{result.inspect}\n \n"

    direct_affiliate_name_result, direct_linkshare_advertisers,  direct_avant_advertisers, direct_cj_advertisers, direct_pj_advertisers, direct_ir_advertisers = search_all_affiliates_by_name(search_intent, search)
    Rails.logger.debug "\n \n RD::::::::::::::#{direct_affiliate_name_result.inspect} \n"
    # search by our categories
    category = ProductCategory.relevant_search(search)

    if category.present? && direct_linkshare_advertisers.empty? && direct_avant_advertisers.empty? && direct_cj_advertisers.empty? && direct_pj_advertisers.empty? && direct_ir_advertisers.empty?
      max_advertisers = 14
      max_cj, max_linkshare, max_avant, max_pj, max_ir = 6, 4, 4, 4, 4

      avant_advertisers = AvantAdvertiser.fetch_advertisers_for_primary_cat(category, max_advertisers)
      cj_advertisers = CjAdvertiser.fetch_advertisers_for_primary_cat(category, max_advertisers)
      linkshare_advertisers = LinkshareAdvertiser.fetch_advertisers_for_primary_cat(category, max_advertisers)
      pj_advertisers = PjAdvertiser.fetch_advertisers_for_primary_cat(category, max_advertisers)
      ir_advertisers = IrAdvertiser.fetch_advertisers_for_primary_cat(category, max_advertisers)

      from_cj, from_linkshare, from_avant, from_pj, from_ir = [cj_advertisers.length, max_cj].min, [linkshare_advertisers.length, max_linkshare].min, [avant_advertisers.length, max_avant].min, [pj_advertisers.length, max_pj].min, [ir_advertisers.length, max_ir].min

      rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
      if rest > 0
        from_cj = cj_advertisers.length > max_cj ? [cj_advertisers.length, from_cj + rest].min : from_cj
        rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
        if rest > 0
          from_linkshare = linkshare_advertisers.length > max_linkshare ? [linkshare_advertisers.length, from_linkshare + rest].min : from_linkshare
          rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
          if rest > 0
            from_avant = avant_advertisers.length > max_avant ? [avant_advertisers.length, from_avant + rest].min : from_avant
            rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
            if rest > 0
              from_pj = pj_advertisers.length > max_pj ? [pj_advertisers.length, from_pj + rest].min : from_pj
              rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
              if rest > 0
                from_ir = ir_advertisers.length > max_ir ? [ir_advertisers.length, from_ir + rest].min : from_ir
                rest = max_advertisers - (from_cj + from_linkshare + from_avant + from_pj + from_ir)
              end
            end
          end
        end
      end

      avant_advertisers = avant_advertisers.first(from_avant)
      cj_advertisers = cj_advertisers.first(from_cj)
      linkshare_advertisers = linkshare_advertisers.first(from_linkshare)
      pj_advertisers = pj_advertisers.first(from_pj)
      ir_advertisers = ir_advertisers.first(from_ir)

      cj_advertisers.map! { |cj| [cj, nil, CJ.get_product_search_request(search, cj.advertiser_id)] }
      avant_advertisers.map! { |avant| [avant, nil, Avant.get_product_search_request(search, avant.advertiser_id, search_intent.id)] }
      linkshare_advertisers.map! { |linkshare| [linkshare, nil, Linkshare.get_product_search_request(search, linkshare.advertiser_id)] }
      pj_advertisers.map! { |pj| [pj, nil, PJ.get_product_search_request(search, pj.advertiser_id)] }
      ir_advertisers.map! { |ir| [ir, nil, nil] }


      # search product offer for Avant
      avant_advertisers.each_with_index do |advertiser, index|
        request = advertiser[2]
        request.on_complete do |response|
          if response.success?
            body = Hash.from_xml(response.body)
            avant_result = Avant.check_result body
            if avant_result
              offer = AvantOffer.new.set_attributes_from_response_row(avant_result[0])
              avant_advertisers[index][1] = offer
            end
          end
        end
        hydra.queue(request)
      end

      # search product offer for CJ
      cj_advertisers.each_with_index do |advertiser, index|
        request = advertiser[2]
        request.on_complete do |response|
          if response.success?
            body = Hash.from_xml(response.body)
            cj_result = CJ.check_result body
            if cj_result && cj_result['products'] && cj_result['products']['product']
              offer = CjOffer.new.set_attributes_from_response_row(cj_result['products']['product'])
              cj_advertisers[index][1] = offer
            end
          end
        end
        hydra.queue(request)
      end

      # search product offer for Linkshare
      linkshare_advertisers.each_with_index do |advertiser, index|
        request = advertiser[2]
        request.on_complete do |response|
          if response.success?
            body = Hash.from_xml(response.body)
            if body && body['result'] && body['result']['item']
              offer = LinkshareOffer.new.set_attributes_from_response_row(body['result']['item'])
              linkshare_advertisers[index][1] = offer
            end
          end
        end
        hydra.queue(request)
      end

      # search product offer for PJ
      pj_advertisers.each_with_index do |advertiser, index|
        request = advertiser[2]
        request.on_complete do |response|
          body = JSON.parse(response.response_body)
          if response.success?
            if body && body['data']
              offer = PJ.set_offer_attributes_from_response_row(body['data'])
              pj_advertisers[index][1] = offer
            end
          end
        end
        hydra.queue(request)
      end

      hydra.run
      # combine all results and render as json
      combined_affiliate_data = (cj_advertisers + avant_advertisers + linkshare_advertisers + pj_advertisers + ir_advertisers).reverse
      Search::Merchant.transaction do
        combined_affiliate_data.each do |val|
          if val[0].is_a?(CjAdvertiser)
            merchant = Search::CjMerchant.where(db_id: val[0].id, intent_id: search_intent.id).first_or_initialize
          elsif val[0].is_a?(AvantAdvertiser)
            merchant = Search::AvantMerchant.where(db_id: val[0].id, intent_id: search_intent.id).first_or_initialize
          elsif val[0].is_a?(LinkshareAdvertiser)
            merchant = Search::LinkshareMerchant.where(db_id: val[0].id, intent_id: search_intent.id).first_or_initialize
          elsif val[0].is_a?(PjAdvertiser)
            merchant = Search::PjMerchant.where(db_id: val[0].id, intent_id: search_intent.id).first_or_initialize
          else
            merchant = Search::IrMerchant.where(db_id: val[0].id, intent_id: search_intent.id).first_or_initialize
          end
          merchant.set_attributes_from_search val[0], val[1], self
          result << merchant.attributes if merchant.save!
        end
      end
    end

    # Sort by money desc (put affiliate merchants to the end)
    result = direct_affiliate_name_result + result.sort_by { |k| k['user_money'].is_a?(String) ? -1 : k['user_money'] }.reverse
    render :json => result
  end

  def search_all_affiliates_by_name(search_intent, search)
    # ======================= Load affiliate merchants =======================
    # search by name
    direct_affiliate_name_result = []
    direct_linkshare_advertisers = LinkshareAdvertiser.relevant_search(search)
    if direct_linkshare_advertisers.length > 0
      Search::LinkshareMerchant.transaction do
        direct_linkshare_advertisers.each do |linkshare_advertiser|
          merchant = Search::LinkshareMerchant.where(db_id: linkshare_advertiser.id,intent_id: search_intent.id).first_or_initialize
          merchant.set_attributes_from_search linkshare_advertiser, nil, self
          direct_affiliate_name_result << merchant.attributes if merchant.save!
        end
      end
    end

    direct_avant_advertisers = AvantAdvertiser.relevant_search(search)
    if direct_avant_advertisers.length > 0
      Search::AvantMerchant.transaction do
        direct_avant_advertisers.each do |avant_advertiser|
          merchant = Search::AvantMerchant.where(db_id: avant_advertiser.id, intent_id: search_intent.id).first_or_initialize
          merchant.set_attributes_from_search avant_advertiser, nil, self
          direct_affiliate_name_result << merchant.attributes if merchant.save!
        end
      end
    end

    direct_cj_advertisers = CjAdvertiser.relevant_search(search)
    if direct_cj_advertisers.length > 0
      Search::CjMerchant.transaction do
        direct_cj_advertisers.each do |cj_advertiser|
          merchant = Search::CjMerchant.where(db_id: cj_advertiser.id, intent_id: search_intent.id).first_or_initialize
          merchant.set_attributes_from_search cj_advertiser, nil, self
          direct_affiliate_name_result << merchant.attributes if merchant.save!
        end
      end
    end

    direct_pj_advertisers = PjAdvertiser.relevant_search(search)
    if direct_pj_advertisers.length > 0
      Search::PjMerchant.transaction do
        direct_pj_advertisers.each do |pj_advertiser|
          merchant = Search::PjMerchant.where(db_id: pj_advertiser.id, intent_id: search_intent.id).first_or_initialize
          merchant.set_attributes_from_search pj_advertiser, nil, self
          direct_affiliate_name_result << merchant.attributes if merchant.save!
        end
      end
    end

    direct_ir_advertisers = IrAdvertiser.relevant_search(search)
    if direct_ir_advertisers.length > 0
      Search::IrMerchant.transaction do
        direct_ir_advertisers.each do |ir_advertiser|
          merchant = Search::IrMerchant.where(db_id: ir_advertiser.id,intent_id: search_intent.id).first_or_initialize
          merchant.set_attributes_from_search ir_advertiser, nil, self
          direct_affiliate_name_result << merchant.attributes if merchant.save!
        end
      end
    end
    return [direct_affiliate_name_result, direct_linkshare_advertisers,  direct_avant_advertisers, direct_cj_advertisers, direct_pj_advertisers, direct_ir_advertisers]
  end
  
  def merchants_search
    search = params[:search_by_merchants].strip
    @search_text = search
    search = search
    begin
      if current_user.present?
        search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
      else
        search_intent = Search::Intent.where(search: search, search_date: Date.today).first_or_create
      end
    rescue ActiveRecord::RecordNotUnique
      render :json => [] and return
    end
    
    avant = AvantAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    cj = CjAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    linkshare = LinkshareAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    pj = PjAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    ir = IrAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    product_category = ProductCategory.where("LOWER(name) LIKE ?", "%#{search}%").first
    if avant.present? or cj.present? or linkshare.present? or pj.present? or ir.present?
      if avant
        @advertiser = avant.class.name.constantize.where("advertiser_id =?", avant.advertiser_id).first
        @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
        @user_coupons = @advertiser.user_coupons.where("admin_approve =?", true)
        if current_user.present?
          @favorite_merchant = FavoriteMerchant.find_by_user_id_and_advertisable_id(current_user.id, @advertiser.id)
        end

      elsif cj
        @advertiser = cj.class.name.constantize.where("advertiser_id =?", cj.advertiser_id).first
        @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
        @user_coupons = @advertiser.user_coupons.where("admin_approve =?", true)
        if current_user.present?
          @favorite_merchant = FavoriteMerchant.find_by_user_id_and_advertisable_id(current_user.id, @advertiser.id)
        end
        
      elsif linkshare
        @advertiser = linkshare.class.name.constantize.where("advertiser_id =?", linkshare.advertiser_id).first
        @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
        @user_coupons = @advertiser.user_coupons.where("admin_approve =?", true)
        if current_user.present?
          @favorite_merchant = FavoriteMerchant.find_by_user_id_and_advertisable_id(current_user.id, @advertiser.id)
        end
        
      elsif pj
        @advertiser = pj.class.name.constantize.where("advertiser_id =?", pj.advertiser_id).first
        @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
        @user_coupons = @advertiser.user_coupons.where("admin_approve =?", true)
        if current_user.present?
          @favorite_merchant = FavoriteMerchant.find_by_user_id_and_advertisable_id(current_user.id, @advertiser.id)
        end
        
      elsif ir
        @advertiser = ir.class.name.constantize.where("advertiser_id =?", ir.advertiser_id).first
        @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
        @user_coupons = @advertiser.user_coupons.where("admin_approve =?", true)
        if current_user.present?
          @favorite_merchant = FavoriteMerchant.find_by_user_id_and_advertisable_id(current_user.id, @advertiser.id)
        end
        
      end
    elsif product_category
      @product_results_cj = product_category.cj_advertisers
      @product_results_avant = product_category.avant_advertisers
      @product_results_pj = product_category.pj_advertisers
      @product_results_ir = product_category.ir_advertisers 
    else
      redirect_to "/"
      return
    end 
    render :layout => "new_application"
  end
  
  def add_favorite_merchant
    @favorite_merchant = FavoriteMerchant.new(
      :user_id => current_user.id,
      :advertisable_id => params[:advertisable_id],
      :advertisable_type => params[:advertisable_type],
    )
    @merchant = params[:advertisable_type].constantize.find(params[:advertisable_id])
    if @favorite_merchant.save
      @status = true
      @message = 'Merchant has successfully being added to the Favorite List'
    else
      @message = 'Merchant can not be added to the Favorite List'
    end
    respond_to do |format|
      format.js {flash[:notice] = "Saved!"}
      format.html{ render :layout => false }
    end
  end
  
  def remove_favorite_merchant
    @favorite_merchant =FavoriteMerchant.find(params[:id])
    if @favorite_merchant.destroy
      @status = true
      @message = 'Merchant has successfully being removed from the Favorite List'
    else
      @message = 'Merchant can not be removed from the Favorite List'
    end
    respond_to do |format|
      format.js {flash[:notice] = "Saved!"}
      format.html{ render :layout => false }
    end
  end

  def hp_merchants_search
    @results = []
    
    search = params[:search_by_merchants].strip
    search = search
    # .downcase.gsub(/[!@%'s'S&-,";]/,'')
    begin
      if current_user.present?
        search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
      else
        search_intent = Search::Intent.where(search: search, search_date: Date.today).first_or_create
       
      end
    rescue ActiveRecord::RecordNotUnique
      render :json => [] and return
    end
    @results = []
    @product_results_cj = []
    @product_results_pj = []
    @product_results_ir = []
    @product_results_avant = []
    avant = AvantAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    cj = CjAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    linkshare = LinkshareAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    pj = PjAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    ir = IrAdvertiser.where('inactive != 1 and LOWER(name) LIKE ?', "%#{search}%").first
    product_category = ProductCategory.where("LOWER(name) LIKE ?", "%#{search}%").first
    if avant.present? or cj.present? or linkshare.present? or pj.present? or ir.present?
     
      if avant
        merchant = Search::AvantMerchant.where(db_id: avant.id, intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search avant, nil, self
        if merchant.save!
          @results << merchant.attributes 
          @similar_merchants = AvantAdvertiser.where('inactive != 1').limit(4)
        end
        puts "avant"
      elsif cj
        merchant = Search::CjMerchant.where(db_id: cj.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search cj, nil, self
        if merchant.save!
          @results << merchant.attributes 
          @similar_merchants = CjAdvertiser.where('inactive != 1').limit(4)
        end
      elsif linkshare
        merchant = Search::LinkshareMerchant.where(db_id: linkshare.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search linkshare, nil, self
        if merchant.save!
          @results << merchant.attributes
          @similar_merchants = LinkshareAdvertiser.where('inactive != 1').limit(4)
        end
        puts "linkshare"
      elsif pj
        merchant = Search::PjMerchant.where(db_id: pj.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search pj, nil, self
        if merchant.save!
          @results << merchant.attributes
          @similar_merchants =  PjAdvertiser.where('inactive != 1').limit(4)
        end
        puts "pj"
      elsif ir
        merchant = Search::IrMerchant.where(db_id: ir.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search ir, nil, self
        if merchant.save!
          @results << merchant.attributes
          @similar_merchants = IrAdvertiser.where('inactive != 1').limit(4) 
        end
        puts "ir"
      end
    elsif product_category
      @product_results_cj = product_category.cj_advertisers
      @product_results_avant = product_category.avant_advertisers
      @product_results_pj = product_category.pj_advertisers
      @product_results_ir = product_category.ir_advertisers  
    end 
    if @results.blank? and @product_results_cj.blank? and @product_results_pj.blank? and @product_results_ir.blank? and @product_results_avant.blank?
      direct_affiliate_name_result, direct_linkshare_advertisers,  direct_avant_advertisers, direct_cj_advertisers, direct_pj_advertisers, direct_ir_advertisers = search_all_affiliates_by_name(search_intent, search)
      @results = direct_affiliate_name_result
      #  render 'users/index' 
      # # redirect_to admins_add_storecat_to_merchant_add_merchant_path
      # # redirect_to add_merchant_admin_add_storecat_to_merchant_path
      puts "blank"
    end
    render :layout => "new_application"
  end
  
  def hp_pc_merchants
    category = ProductCategory.where(id: params[:pcid]).find
    @advertisers = category.cj_advertisers.limit(5) + category.avant_advertisers.limit(5) + category.linkshare_advertisers.limit(5) + category.pj_advertisers.limit(5) + category.ir_advertisers.limit(5)
    render :layout => "new_application"
  end

  def prompt_zipcode_window
    render :layout => "new_resp_popup"
  end

  def hp_services_search_old
    puts "@@@@@@@@@@@@@@@@ in the hp services search" 
    search = (params[:service_keyword] || params[:search_by_services]).strip
    zip_code = !(params[:zip_code].blank?)  ?  (params[:zip_code]) : (current_user.zip_code)
    begin
      if !(current_user.blank?)
        if current_user.zip_code.blank?
          current_user.zip_code = zip_code
          current_user.save(:validate => false)
        end
        search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
          
      else
        search_intent = Search::Intent.where(search: search, search_date: Date.today).first_or_create
        
      end
    rescue ActiveRecord::RecordNotUnique
      render :json => [] and return
    end
    puts "@@@@@@@@@@@@@@@@ search",search
    puts "@@@@@@@@@@@@@@@@ search_intent", search_intent.inspect
    puts "@@@@@@@@@@@@@@@@ zip code", zip_code 
    @results = search_soleo_and_local_merchants_db(search, search_intent, zip_code)
    @more_deals_total = 0
    @results.each do |r| @more_deals_total = @more_deals_total + r['user_money'].to_f end
    puts "@@@@@@@@@@@@@@@@@@@@@@ results", @results.inspect
    puts "@@@@@@@@@@@@@@@@@@@@@@ results---------"
    render :layout => "new_resp_popup"
  end
  
  def hp_services_search
    search = params[:service_keyword].strip
    zip_code = !(params[:zip_code].blank?)  ?  (params[:zip_code]) : current_user.try(:zip_code)
    if zip_code
      begin
        if current_user
          if current_user.zip_code.blank?
            current_user.zip_code = zip_code
            current_user.save(:validate => false)
          end
          search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create

        else
          search_intent = Search::Intent.where(search: search, search_date: Date.today, user_id: nil).first_or_create

        end
      rescue ActiveRecord::RecordNotUnique
        render :json => [] and return
      end
      @results = search_soleo_and_local_merchants_db(search, search_intent, zip_code)
      @more_deals_total = 0
      @results.each do |r| @more_deals_total = @more_deals_total + r['user_money'].to_f end
    else
      #show zipcode popup
      @results = nil
    end
    render :layout => "new_resp_popup"
  end

  def prompt_cc_window
    @advertiser = params[:type].constantize.where("advertiser_id =?", params[:ad]).first
    @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
    @advertiser_url = params[:offer_url]
    @user_coupon = @advertiser.user_coupons.new if @advertiser.present?
    @user_coupon = UserCoupon.new if @user_coupon.blank?
    @store_link = get_store_link(@advertiser, params[:type])
    render :layout => 'new_resp_popup'
  end

  def get_store_link(advertiser, advertiser_type)
    store_link = ''
    if advertiser.present? && advertiser_type.present?
      case advertiser_type
      when 'IrAdvertiser' then
        store_link = advertiser.params['AdvertiserUrl'] if advertiser.params.present?
      when 'LinkshareAdvertiser' then
        store_link = advertiser.website
      when 'CjAdvertiser' then
        store_link = advertiser.params['program_url'] if advertiser.params.present?
      when 'AvantAdvertiser' then
        store_link = advertiser.advertiser_url
      when 'PjAdvertiser' then
        store_link = advertiser.params['website'] if advertiser.params.present?
      end
    end
    store_link
  end

  def get_current_user
    render :json => get_user_info(current_user)
  end

  def affiliate_search
    render :json => nil and return unless current_user
    links = params[:links]
    search = params[:search]
    begin
      search_intent = Search::Intent.where(search: search, user_id: current_user.id, search_date: Date.today).first_or_create
    rescue ActiveRecord::RecordNotUnique
      render :json => nil and return
    end

    results = []
    links.each do |link|
      uri = URI.parse(link).host
      if uri.nil?
        results << nil
        next
      end
      avant = AvantAdvertiser.where('inactive != 1 and advertiser_url LIKE ?', "%#{uri}%").first
      cj = CjAdvertiser.where('inactive != 1 and params LIKE ?', "%#{uri}%").first
      linkshare = LinkshareAdvertiser.where('inactive != 1 and website LIKE ?', "%#{uri}%").first
      pj = PjAdvertiser.where('inactive != 1 and params LIKE ?', "%#{uri}%").first
      ir = IrAdvertiser.where('inactive != 1 and params LIKE ?', "%#{uri}%").first

      if avant
        merchant = Search::AvantMerchant.where(db_id: avant.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search avant, nil, self
        results << merchant.attributes if merchant.save!
      elsif cj
        merchant = Search::CjMerchant.where(db_id: cj.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search cj, nil, self
        results << merchant.attributes if merchant.save!
      elsif linkshare
        merchant = Search::LinkshareMerchant.where(db_id: linkshare.id, intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search linkshare, nil, self
        results << merchant.attributes if merchant.save!
      elsif pj
        merchant = Search::PjMerchant.where(db_id: pj.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search pj, nil, self
        results << merchant.attributes if merchant.save!
      elsif ir
        merchant = Search::IrMerchant.where(db_id: ir.id,intent_id: search_intent.id).first_or_initialize
        merchant.set_attributes_from_search ir, nil, self
        results << merchant.attributes if merchant.save!
      else
        results << nil
      end
    end
    render :json => results
  end

  def activate_merchant
    render :nothing => true and return if params[:id].nil? || current_user.nil?
    merchant = Search::Merchant.find(params[:id])
    merchant.active = true
    merchant.save

    if merchant.type == Search::LocalMerchant.name
      campaign = Campaign.find(merchant.db_id)
      offer = Offer.find(merchant.other_db_id)
      campaign.total_spent = 0 if campaign.total_spent.nil?
      offer.total_spent = 0 if offer.total_spent.nil?
      campaign.total_spent += merchant.user_money.to_f
      offer.total_spent += merchant.user_money.to_f
      campaign.save
      offer.save
    end

    search_intent = merchant.intent
    search_intent.has_active_service_merchants = merchant.type == Search::SoleoMerchant.name || merchant.type == Search::LocalMerchant.name
    search_intent.status = Search::Intent::STATUSES[0] if merchant.intent.status.nil? # active
    search_intent.save

    # soleo refresh session
    if session[:soleo_category_search] && merchant.type == Search::SoleoMerchant.name && merchant.params['expired_at'] < Time.now
      logger.info '******* Soleo merchant expired: [merchant_id]' + merchant.id.to_s + '[merchant_company]' + merchant.company_name + '[merchant_phone]' + merchant.company_phone + '[intent_id]' + search_intent.id.to_s + '[search]' + search_intent.search
      # ======================= Soleo prepare XML =======================
      builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
        xml.request('client-tracking-id' => search_intent.id, :xmlns => 'http://soleosearch.flexiq.soleo.com') {
          xml.send('pay-per-call') {
            {'business-name' => nil, :zip => current_user.zip_code, 'category-name' => session[:soleo_category_search], 'auto-decode' => false, 'result-size' => 12, 'sort-by' => 'value'}.each { |k, v| xml.send(k, v) }
          }
        }
      end

      # ======================= Soleo run request =======================
      t_request = Typhoeus::Request.new('https://xapi.soleocom.com/xapi/query', :method => :post, :userpwd => $soleo_basic_auth, :body => builder.to_xml)
      t_request.on_complete do |response|
        if response.success?
          body = Hash.from_xml(response.body)['response']
          logger.info "******* #{Time.now.in_time_zone('Eastern Time (US & Canada)').strftime('%m-%d-%y %I-%M-%S %p')} : Soleo refreshed listings for #{search_intent.search} : "
          logger.info '******* ' + response.body.to_s
          if body['pay_per_call']['available_listings'] != '0'
            position = 0
            listings = body['pay_per_call']['listings']['listing'].is_a?(Array) ? body['pay_per_call']['listings']['listing'] : [body['pay_per_call']['listings']['listing']]
            Search::SoleoMerchant.transaction do
              listings.each do |listing|
                position += 1
                existing_merchant = Search::SoleoMerchant.find_by_company_name_and_company_phone_and_intent_id(listing['business_name'], listing['ppc_details']['connect_number'], search_intent.id)
                unless existing_merchant.nil?
                  existing_merchant.set_attributes_from_search listing, position
                  existing_merchant.save
                end
              end
            end
            search_intent.delay(:run_at => Time.now + Search::SoleoMerchant::CALLBACK_DELAY.seconds).send_soleo_callback
          end
        end
      end
      t_request.run
    end

    render :text => 1
  end

  def shopping_info
    render :layout => false
  end

  def avant_mapping
    @advertisers = AvantAdvertiser.where('inactive != 1').order('name asc').all.to_a
    render :layout => false
  end

  def cj_mapping
    @advertisers = CjAdvertiser.where('inactive != 1').order('name asc').all.to_a
    render :layout => false
  end

  def pj_mapping
    @advertisers = PjAdvertiser.where('inactive != 1').order('name asc').all.to_a
    render :layout => false
  end

  def linkshare_mapping
    @api_map = {
      17 => ['Business & Career',
        {150 => 'B-to-B',
          151 => 'Employment',
          152 => 'Real Estate'}],
      18 => ['Department Store',
        {153 => 'Clothing',
          154 => 'Gifts',
          155 => 'Home',
          247 => 'Jewelry'}],
      19 => ['Family',
        {156 => 'Baby',
          157 => 'Education',
          158 => 'Entertainment',
          159 => 'Pets'}],
      21 => ['Telecommunications',
        {211 => 'Equipment',
          212 => 'Long Distance',
          213 => 'Wireless'}],
      1 => ['Hobbies & Collectibles',
        {101 => 'Art',
          102 => 'Auctions',
          103 => 'Collectibles'}],
      2 => ['Auto',
        {104 => 'Accessories',
          105 => 'Cars',
          106 => 'Rentals'}],
      3 => ['Clothing & Accessories',
        {207 => 'Children',
          107 => 'Accessories',
          108 => 'Men',
          109 => 'Women',
          246 => 'Jewelry'}],
      4 => ['Computer & Electronics',
        {110 => 'Hardware',
          111 => 'Consumer',
          112 => 'Software'}],
      5 => ['Entertainment',
        {113 => 'Books/Magazines',
          114 => 'Music',
          115 => 'Videos'}],
      6 => ['Financial Services',
        {116 => 'Banking/Trading',
          117 => 'Credit Cards',
          118 => 'Loans'}],
      7 => ['Food & Drink',
        {218 => 'Candy',
          119 => 'Cigars',
          120 => 'Gourmet',
          121 => 'Wine'}],
      8 => ['Games & Toys',
        {122 => 'Children',
          123 => 'Educational',
          124 => 'Electronic'}],
      9 => ['Gift & Flowers',
        {125 => 'Gifts',
          126 => 'Flowers',
          127 => 'Greeting Cards'}],
      10 => ['Health & Beauty',
        {229 => 'Prescription',
          128 => 'Bath/Body',
          129 => 'Cosmetics',
          130 => 'Vitamins',
          11248 => 'Medical Supplies & Services'}],
      11 => ['Home & Living',
        {232 => 'Improvement',
          131 => 'Bed/Bath',
          132 => 'Garden',
          133 => 'Kitchen'}],
      12 => ['Mature/Adult',
        {134 => 'Apparel',
          135 => 'Books',
          136 => 'Entertainment'}],
      13 => ['Office',
        {137 => 'Equipment',
          138 => 'Home Office',
          139 => 'Supplies'}],
      14 => ['Sports & Fitness',
        {140 => 'Clothing',
          141 => 'Collectibles',
          142 => 'Equipment'}],
      15 => ['Travel',
        {245 => 'Vacations',
          143 => 'Airline',
          144 => 'Car',
          145 => 'Hotel'}],
      16 => ['Internet & Online',
        {149 => 'Programs',
          146 => 'Services',
          147 => 'Development',
          148 => 'Hosting',
          16249 => 'Online Dating'}],
      20 => ['Miscellaneous',
        {210 => 'Other, Other Products/Services'}]}.sort_by { |key, val| key }

    @advertisers = LinkshareAdvertiser.where('inactive != 1').order('name asc').all.to_a
    @advertisers.each do |adv|
      adv[:cats] = adv.params['categories'].split(' ')
      adv[:cats].map! { |cat| cat.to_i }
    end
    render :layout => false
  end


  def rtest
    cat = nil
    unless params[:search].blank?
      search = params[:search]
      if /\b(?:ISBN(?:: ?| ))?((?:97[89])?\d{9}[\dx])\b/i.match(search)
        search = 'College and University'
      end
      cat = ProductCategory.relevant_search(search)
      @soleo_cat = SoleoCategory.relevant_search(search)
      @soleo_parent_cat = @soleo_cat.parent.parent if @soleo_cat
      @avant_relevant = AvantAdvertiser.relevant_search(search).map(&:name).join(', ')
      @cj_relevant = CjAdvertiser.relevant_search(search).map(&:name).join(', ')
      @linkshare_relevant = LinkshareAdvertiser.relevant_search(search).map(&:name).join(', ')
    end
    if cat
      @result = "<b>#{cat.name}</b>"
      @result = cat.parent.name + ' >> ' + @result if cat.parent
      @result = cat.parent.parent.name + ' >> ' + @result if cat.parent && cat.parent.parent

      max_advertisers = 14
      max_cj, max_linkshare, max_avant = 6, 4, 4

      # Primary (3rd category)
      avant_advertisers = AvantAdvertiser.fetch_advertisers_for_primary_cat(cat, max_advertisers)
      cj_advertisers = CjAdvertiser.fetch_advertisers_for_primary_cat(cat, max_advertisers)
      linkshare_advertisers = LinkshareAdvertiser.fetch_advertisers_for_primary_cat(cat, max_advertisers)

      from_cj, from_linkshare, from_avant = [cj_advertisers.length, max_cj].min, [linkshare_advertisers.length, max_linkshare].min, [avant_advertisers.length, max_avant].min

      rest = max_advertisers - (from_cj + from_linkshare + from_avant)
      if rest > 0
        from_cj = cj_advertisers.length > max_cj ? [cj_advertisers.length, from_cj + rest].min : from_cj
        rest = max_advertisers - (from_cj + from_linkshare + from_avant)
        if rest > 0
          from_linkshare = linkshare_advertisers.length > max_linkshare ? [linkshare_advertisers.length, from_linkshare + rest].min : from_linkshare
          rest = max_advertisers - (from_cj + from_linkshare + from_avant)
          if rest > 0
            from_avant = avant_advertisers.length > max_avant ? [avant_advertisers.length, from_avant + rest].min : from_avant
            rest = max_advertisers - (from_cj + from_linkshare + from_avant)
          end
        end
      end

      @cj_advertisers = cj_advertisers.first(from_cj).map(&:name).join(', ')
      @linkshare_advertisers = linkshare_advertisers.first(from_linkshare).map(&:name).join(', ')
      @avant_advertisers = avant_advertisers.first(from_avant).map(&:name).join(', ')

    end
    render :layout => 'application'
  end

  def rupload
    if params[:mmsearchlogo]
      unless File.exist? Rails.root.join('public', 'system', 'search_logo')
        Dir.mkdir Rails.root.join('public', 'system', 'search_logo')
      end
      if %w(image/png image/jpeg image/jpg image/gif).include? params[:mmsearchlogo].content_type
        FileUtils.rm_rf(Dir.glob(Rails.root.join('public', 'system', 'search_logo/*')))
        File.open(Rails.root.join('public', 'system', 'search_logo', params[:mmsearchlogo].original_filename), 'wb') do |file|
          file.write(params[:mmsearchlogo].read)
        end
        flash[:notice] = 'Successfully uploaded.'
      else
        flash[:alert] = 'Wrong file type.'
      end
    end
    redirect_to :action => :rtest
  end

  def extension_background_iframe
    render :layout => false
  end

  def mm_soleo_number_clicks_report
    @report = Search::SoleoMerchant.preload(:intent).where(:active => 1).order('created_at desc').all
    render :layout => false
  end

  def skip_info_before_shopping
    session[:skip_info_before_shopping] = true
    render :nothing => true
  end

  def check_coupons_by_location
    lng, lat = params[:lng], params[:lat]
    #lat, lng = "42.955966", "-71.43216"
    #lat,lng = "34.1450226", "-118.2596976"
    if lng.present? && lat.present? && current_user.present?
      begin
        #Google Places API Request
        google_business_names = request_google_places_api(lat,lng)
        #FourSquare  API Request
        fs_business_names = request_foursquare_api(lat,lng)
        merchants_by_stores = Store.geo_scope(:within => 10, :units => :kms, :origin => [lat,lng]).map{|s| s.storable if s.storable.coupons.present?}.uniq.compact
        puts "\n MERCHANTSN:::#{merchants_by_stores.collect(&:name).inspect} \n"
        names = (google_business_names + fs_business_names).uniq
        cj_merchants, aa_merchants, la_merchants, pj_merchants, ir_merchants = [], [], [], [], []
        #Finding merchants in all affiliates
        names.each do |business_name|
          cj_merchants.push(find_merchants("CjAdvertiser", business_name))
          aa_merchants.push(find_merchants("AvantAdvertiser", business_name))
          la_merchants.push(find_merchants("LinkshareAdvertiser", business_name))
          pj_merchants.push(find_merchants("PjAdvertiser", business_name))
          ir_merchants.push(find_merchants("IrAdvertiser", business_name))
        end
        #Merging all merchants found
        merchants = (cj_merchants.flatten + aa_merchants.flatten + la_merchants.flatten + pj_merchants.flatten + ir_merchants.flatten + merchants_by_stores).compact.uniq
        #Check whether an previous update history was already sent for a merchant, for a user on current day
        puts "\n \n FMN::::#{merchants.collect(&:name).inspect} \n \n"
        final_merchants = []
        merchants.each do |merchant|
          user_update = merchant.mcb_updates.where("user_id = ? AND alert_date = ?", current_user.id, Date.today.strftime('%Y-%m-%d')).first
          final_merchants << merchant if user_update.blank?
        end

        # Creating a update and sending email update.
        if !final_merchants.blank?
          final_merchants.map{|m| m.mcb_updates.create({ :user_id => current_user.id, :alert_date => Date.today.strftime('%Y-%m-%d')})}
          SearchMailer.coupons_available_near_user(final_merchants, current_user).deliver
        end
        render :json => merchants and return

      rescue StandardError => e
        puts 'GPS::Error::' + e.message
        render :nothing => true and return
      end
    end
    render :nothing => true
  end

  def find_merchants(merchant_name, business_name)
    merchant_name.constantize.select("DISTINCT #{merchant_name.pluralize.underscore}.*").joins(:coupons).where("name LIKE (?)", "%#{business_name}%")
  end

  def request_foursquare_api(lat,lng)
    fs_client =  Foursquare2::Client.new(:client_id => $fs_client_id, :client_secret => $fs_client_secret)
    venues = fs_client.search_venues(:ll => "#{lat},#{lng}", :v => Date.today.strftime("%Y%m%d"), :limit => 50).venues
    (venues.blank?) ? [] : venues.map{|h| h.name}
  end

  def request_google_places_api(lat,lng)
    google_client = GooglePlaces::Client.new($g_api_key)
    spots = google_client.spots(lat, lng, :radius => 100, :type => Search.google_places_api_categories_list)
    if spots.blank?
      spots = google_client.spots(lat, lng, :radius => 100)
    else
      more_spots = google_client.spots(lat, lng, :radius => 100)
      spots = spots + more_spots
    end
    (spots.blank?) ? [] : spots.collect { |spot| spot.name }.uniq
  end

  def autocomplete_muddleme_search
    avant = AvantAdvertiser.where("LOWER(name) LIKE ?", "#{params[:term].downcase}%").limit(10).map(&:name)
    cj = CjAdvertiser.where("LOWER(name) LIKE ?", "#{params[:term].downcase}%").map(&:name)
    linkshare = LinkshareAdvertiser.where("LOWER(name) LIKE ?", "#{params[:term].downcase}%").map(&:name)
    pj = PjAdvertiser.where("LOWER(name) LIKE ?", "#{params[:term].downcase}%").map(&:name)
    ir = IrAdvertiser.where("LOWER(name) LIKE ?", "#{params[:term].downcase}%").map(&:name)
    arr = avant + cj + linkshare + pj + ir
    arr = arr.collect {|a| {title: a.gsub(".com","")} }
    p arr
    render :json => arr
  end
  
  def autocomplete_service_search
    service_categories = ServiceCategory.where("LOWER(name) LIKE ?", "#{params[:term]}%").limit(10).map(&:name)
    render :json => service_categories
  end

end
