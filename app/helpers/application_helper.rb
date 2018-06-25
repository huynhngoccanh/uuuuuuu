module ApplicationHelper


  def numbered_input form, attribute, simple_form_options={}
    @numbered_input_counters ||= {}
    @numbered_input_counters[form.object_id] ||= 0
    @numbered_input_counters[form.object_id] += 1

    title = strip_tags(form.label(attribute))

    result = "<span class='num' title='#{title}'>#{@numbered_input_counters[form.object_id]}.</span>"
    result += no_label_input(form, attribute, simple_form_options)
    result.html_safe
  end

  def fetch_image_of_advertiser(advertiser, style)
    advertiser.image.exists? ? advertiser.image.url(style.to_sym) : (advertiser.is_a?(LinkshareAdvertiser) ? advertiser.logo_url : advertiser.logo.url)
  end

  def no_label_input  form, attribute, simple_form_options={}
    title = strip_tags(form.label(attribute, :label=>simple_form_options[:label]))
    options = {:input_html=>{:title=>title}}
    options[:label] = false unless simple_form_options[:use_label]

    defaults = {:placeholder=>title}

    form.input attribute, defaults.merge(simple_form_options.deep_merge(options))
  end

  def input_row form, attribute, simple_form_options={}
    return form.input(attribute, simple_form_options) + tag(:hr)
  end

  def inputs_grouped form, attribute, label=nil, hint=nil, required=nil, &block
    content_tag(:div, :class=>"input grouped") do
      content_tag(:div, :class=>'col desc') do
        form.label(attribute, :label=>label, :required=>required) +
          form.hint(hint.blank? ? attribute : hint)
      end + content_tag(:div, :class=>'col flds') do
        yield
      end
    end + tag(:hr)
  end

  def sub_input_row form, attribute, simple_form_options={}
    form.input(attribute, {:wrapper=>:sub_input}.merge(simple_form_options))
  end

  def times_of_day_options
    [['Any time', '']] + $times_of_day.map { |t| [t,t] }
  end

  def seconds_to_time number_of_seconds
    return '' if number_of_seconds.blank?
    hours = (number_of_seconds/3600).to_i
    minutes = (number_of_seconds/60 - hours * 60).to_i
    seconds = (number_of_seconds - (minutes * 60 + hours * 3600))
    sprintf("%02d:%02d:%02d", hours, minutes, seconds)
  end

  def seconds_to_days_and_time number_of_seconds, include_seconds=true
    return '' if number_of_seconds.blank?
    days = number_of_seconds/(3600 * 24)
    hours = (number_of_seconds/3600 - days *  24).to_i
    minutes = (number_of_seconds.to_f/60.0 - (hours * 60 + days * 24 * 60).to_f)
    minutes = include_seconds ? minutes.to_i : minutes.round
    seconds = (number_of_seconds - (minutes * 60 + hours * 3600 + days * (3600 * 24)))
    if include_seconds
      sprintf("%01dd %01dh %01dm %01ds", days, hours, minutes, seconds)
    else
      sprintf("%01dd %01dh %01dm", days, hours, minutes)
    end
  end

  def seconds_to_days_and_time_html number_of_seconds
    return '' if number_of_seconds.blank?
    days = number_of_seconds/(3600 * 24)
    hours = (number_of_seconds/3600 - days *  24).to_i
    minutes = (number_of_seconds/60 - (hours * 60 + days * 24 * 60)).to_i
    seconds = (number_of_seconds - (minutes * 60 + hours * 3600 + days * (3600 * 24)))
    sprintf("<span class='days'>%01d</span>d <span class='hours'>%01d</span>h <span class='minutes'>%01d</span>m <span class='seconds'>%01d</span>s",
      days, hours, minutes, seconds).html_safe
  end

  def paginate *params
    params[1] = {} if params[1].nil?
    params[1][:renderer] = PaginationViewRenderer
    will_paginate *params
  end

  def format_currency value
    number_to_currency(number_with_precision(value, :precision => 2))
  end

  def format_percent_strip value
    number_to_percentage(value, {:precision=>1, :strip_insignificant_zeros=>true})
  end

  def format_datetime value
    value && value.strftime('%m/%d/%Y at %R')
  end

  def format_date value
    value && value.strftime('%m/%d/%Y')
  end

  def url_without_http url
    url.gsub(/https?:\/\//, '')
  end

  def url_with_http url
    http = /https?:\/\//
    if(url.match(http))
      url
    else
      "http://#{url}"
    end
  end

  def trackable_offer_link auction_id, offer
    return '' if offer.offer_url.blank?
    offer_url = url_with_http(offer.trackable_offer_url(auction_id))
    link = create_vendor_tracking_event_path('clicked', :v=>offer.vendor_id, :a=>auction_id,
      :redirect_to=>offer_url)
    link_to offer.offer_url, offer_url, :target=>'_blank', :class=>'trackable-link', :"data-link"=>link
  end

  def list_order_url list_name, param_name
    dir = :ASC
    if instance_variable_get("@#{list_name}_order").to_sym == param_name.to_sym
      dir = instance_variable_get("@#{list_name}_dir").to_sym == :ASC ? :DESC : :ASC
    end
    url_for(params.merge({:"#{list_name}_order" => param_name, :"#{list_name}_dir"=>dir, :"#{list_name}_page"=>nil}))
  end

  def list_order_class list_name, param_name
    ''
    if instance_variable_get("@#{list_name}_order").to_sym == param_name.to_sym
      'active' + if instance_variable_get("@#{list_name}_dir").to_sym == :DESC
        ' up'
      else
        ''
      end
    end
  end

  def credit_card_types
    [
      ["Visa", "visa"], ["MasterCard", "master"],
      ["Discover", "discover"], ["American Express", "american_express"]
    ]
  end

  def facebok_include_sdk
    '<div id="fb-root"></div>' +
      '<script>(function(d, s, id) {'+
      'var js, fjs = d.getElementsByTagName(s)[0];'+
      'if (d.getElementById(id)) return;'+
      'js = d.createElement(s); js.id = id;'+
      "js.src = '//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{SOCIAL_CONFIG['fb_app_id']}';"+
      'fjs.parentNode.insertBefore(js, fjs);'+
      "}(document, 'script', 'facebook-jssdk'));</script>".html_safe
  end

  def facebook_like_button page_url
    '<div class="fb-like" data-href="' + page_url + '" data-send="false"' +
      ' data-layout="button_count" data-width="450" data-show-faces="false"></div>'.html_safe
  end

  def twitter_tweet_button pager_url, text
    '<a href="https://twitter.com/share" class="twitter-share-button" data-url="'+pager_url+'" data-text="' + text + '">Tweet</a>
    <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>'.html_safe
  end

  def image_tag_unknown_extension(unknown_extension_url)
    extension_code = lambda { |extension|
      url = URI.parse(unknown_extension_url + extension)
      req = Net::HTTP.new(url.host, url.port)
      res = req.request_head(url.path)
      res.code
    }
    jpeg_code = extension_code.call '.jpg'
    if jpeg_code == '404'
      gif_code = extension_code.call '.gif'
      if gif_code == '404'
        png_code = extension_code.call '.png'
        png_code == '404' ? (image_tag 'pixel.gif') : (image_tag unknown_extension_url + '.png')
      else
        image_tag unknown_extension_url + '.gif'
      end
    else
      image_tag unknown_extension_url + '.jpg'
    end
  end

  def get_home_path
    session[:extension_origin].nil? ? google_search_path : session[:extension_origin]
  end

  def check_withdrawal_errors(params)
    params.present? && params == "true"
  end

  def advertiser_coupons(advertiser)
    advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
  end
  
  def most_popular_stores_footer_old
    
    mps_array = ProductCategory::MOST_POPULAR_STORES
    categories = mps_array.keys.sort
#    categories = ProductCategory.where(popular: true).order(:name).map(&:name)
    #mps_array = mps_array.sort
    current_alphabet = ''
    custom_html = []
    custom_html << "<div class='col-2'>"
    current_alphabet = nil
    loop_count = 0
    per_col_count = mps_array.values.flatten.count/6
    
    categories.each do |category|      
      unless category[0] == current_alphabet
        custom_html << "</div>" if current_alphabet
        current_alphabet = category[0]
        custom_html << "<div class='list-#{current_alphabet.downcase}'>"
      end
      custom_html << "<h5>#{category}</h5>"
      custom_html << "<ul>"
      
      merchant_names = mps_array[category]
      #popular_merchant_names = ProductCategory.where(name: merchant_names, popular: true).map(&:name)
      merchant_by_names = ProductCategory.get_merchant_by_names(merchant_names)
      merchant_names.each do |merchant_name|
        if per_col_count <= loop_count
          if current_alphabet
            custom_html << "</div>" 
            current_alphabet = nil
          end
          custom_html << "</ul>"
          
          custom_html << "</div>" #close existing col-2
          custom_html << "<div class='col-2'>"          
          custom_html << "<ul>"
          loop_count = 0
        end
        loop_count += 1
        custom_html << '<li>'
        merchant = merchant_by_names[merchant_name]
        if merchant
          merchant_name = merchant.name.titleize
          if merchant_name.include? "Nhl"
            merchant_name = merchant_name.gsub("Nhl", "NHL")
          end
          if merchant_name.include? "Nba"
            merchant_name = merchant_name.gsub("Nba", "NBA")
          end
          custom_html << '<a href="#" data-reveal-id="no_coupon_code" data-animation="none">'
          custom_html << "#{merchant_name}"
          custom_html << '</a>'
        else
          custom_html << '<a href="#" data-reveal-id="no_coupon_code" data-animation="none">'
          custom_html << "#{merchant_name}"
          custom_html << '</a>'
        end
        custom_html << '</li>'
      end
      custom_html << "</ul>"
      
    end
    custom_html << "</div>" if current_alphabet
    custom_html << "</div>"
    
    custom_html.join("").html_safe
  end
  
  def most_popular_stores_footer
    popular = ProductCategory.where(popular: true).includes({hp_stores: {advertiser: :unexpired_coupons}}).order(name: :asc)
    mps_array = []
    custom_html = []
    popular.each do |pc|
      if pc.hp_stores.present?
        temp_array = []
        pc.hp_stores.each do |pc_hp_store|
          temp_array << pc_hp_store.advertiser.name
          
          @advertiser = pc_hp_store.advertiser
          @coupons = @advertiser.unexpired_coupons
          # if @coupons.present?
    
          #   custom_html << "<div class='coupon-popup reveal-modal popup' id='coupons_cashback_#{pc_hp_store.advertiser.advertiser_id}'>"
          #   custom_html << '<a class="close-reveal-modal">'
          #   custom_html << '<img alt="close" src="assets/close-btn.png"/>'
          #   custom_html << '</a>'
          #   custom_html << '<div class="top">'
          #   custom_html << '<h2>Copy the Code</h2>'
          #   custom_html << '<p>Paste this code at checkout to save</p>'
          #   custom_html << '<div class="coupon-box">'
          #   if @coupons && @coupons.size > 0
          #     custom_html << "<span class='coupon' id='coupon-code-#{@coupons.first.id}'>"
          #     custom_html << "#{@coupons.first.code}"
          #     custom_html << '</span>'
          #     custom_html << "<button class='my_clip_button' data-clipboard-target='coupon-code-#{@coupons.first.id}' id='copy-code-#{@coupons.first.id}' title='Copy Code.'>Copy Code</button>"
          #   else
          #     custom_html << '<span class="coupon">No code</span>'
          #   end
          #   custom_html << '</div>'
          #   custom_html << '<p class="small">'
          #   if @advertiser_url.blank?
          #     custom_html << "Go to <a href='#{@advertiser.base_tracking_url}'>#{@advertiser.name}</a>"
          #     custom_html << "and paste the code at checkout."
          #   else
          #     custom_html << "Go to <a href='#{@advertiser_url}'>#{@advertiser.name}</a>"
          #     custom_html << "and paste the code at checkout."
          #   end
          #   custom_html << '</p>'
          #   custom_html << '</div>'
            
          #   custom_html << '<div class="bottom">'
          #   custom_html << '<figure class="logo">'
          #   custom_html << '<a>'
          #   custom_html << "#{image_tag @advertiser.image.url(:medium), title: @advertiser.name}"
          #   custom_html << '</a>'
          #   custom_html << '</figure>'
          #   unless @coupons.blank?
          #     custom_html << '<h3>'
          #     custom_html << "#{@coupons.first.header}"
          #     custom_html << '</h3>'
          #     custom_html << '<div class="shipping-info">'
          #     custom_html << "#{@coupons.first.description}"
          #     custom_html << '<span class="expires">'
          #     custom_html <<  '<strong>Expiration Date:'
          #     custom_html << '</strong>'
          #     custom_html << "#{@coupons.first.expires_at}"
          #     custom_html << '</span>'
          #     custom_html << '</div>'
          #   else
          #     custom_html << '<h3>Free Shipping And Returns</h3>'
          #     custom_html << '<div class="shipping-info">'
          #     custom_html << "Free Shipping and returns with swim purchase."
          #     custom_html << '<br>'
          #     custom_html << "Valid for free standard shipping and handling."
          #     custom_html << '<br>'
          #     custom_html << '<span class="expires">'
          #     custom_html <<  '<strong>Expiration Date:'
          #     custom_html << '</strong>'
          #     custom_html << "4/1/2016"
          #     custom_html << '</span>'
          #     custom_html << '</div>'
              
          #   end
          #   custom_html << '<div class="cash-back">'
          #   custom_html << '<h4>Cash Back!</h4>'
          #   if @advertiser.advertiser_url
          #     url = URI.parse(@advertiser.advertiser_url)
          #     custom_html << "<p>Deposited directly into your account with any purchase from"
          #     custom_html << '<br>'
          #     custom_html << "<a class='custom-link' href= '#{@advertiser.base_tracking_url}'>#{url}</a></p>"
          #   end
          #   custom_html << '</div>'
          #   custom_html << '</div>'
          #   custom_html << '</div>'
          # else
          #   custom_html << "<div class='reveal-modal popup' id='no_coupon_code_#{pc_hp_store.advertiser.advertiser_id}'>"
          #   custom_html << '<header class="header">'
          #   custom_html << '<h2>No Coupon Codes Required</h2>'
          #   custom_html << '<a class="close-reveal-modal">'
          #   custom_html << "#{image_tag 'close-btn.png'}"
          #   custom_html << '</a>'
          #   custom_html << '</header>'
          #   custom_html << '<div class="popup-content">'
          #   custom_html << '<p>Shop now and make money at'
          #   custom_html << '<br>'
          #   custom_html << "<a class='custom-link' href='#{@advertiser.base_tracking_url}'>#{pc_hp_store.advertiser.advertiser_url}</a>"
          #   custom_html << '</p>'
          #   custom_html << '<div class="button-wrapper row">'
          #   custom_html << "<a class='cutom-link btn' href='#{@advertiser.base_tracking_url}'>"
          #   if @advertiser.advertiser_url.blank?
          #     custom_html << "Go to #{@advertiser.name}"
          #   else
          #     custom_html << "Go to #{@advertiser.name}"
          #   end
          #   custom_html << '</a>'
          #   custom_html << '</div>'
          #   custom_html << '<div class="align-center row">'
          #   custom_html << '<a class="logo" href="#">'
          #   custom_html << "#{image_tag @advertiser.image.url(:medium), title: @advertiser.name}"
          #   custom_html << '</a>'
          #   custom_html << '</div>'
          #   custom_html << '<h4>'
          #   custom_html << 'cash back on all purchases from'
          #   custom_html << '<br>'
          #   custom_html << "<a class='custom-link' href= '#{@advertiser.base_tracking_url}'>#{@advertiser.name}</a>"
          #   custom_html << '</h4>'
          #   custom_html << '</div>'
          #   custom_html << '</div>'
          # end
          
        end
        mps_array << {name: pc.name, store: temp_array}
      end
    end

    current_alphabet = ''
    custom_html << "<div class='col-2'>"
    current_alphabet = nil
    loop_count = 0
    per_col_count = HpStoreProductCategory.count/6
    
    mps_array.each_with_index do |category, i|      
      unless category[:name][0] == current_alphabet
        custom_html << "</div>" if current_alphabet
        current_alphabet = category[:name][0]
        if i > 0 && mps_array[i-1][:name][0] == current_alphabet
          custom_html << "<div>"
        else
          custom_html << "<div class='list-#{current_alphabet.downcase}'>"
        end
      end
      custom_html << "<h5>#{category[:name]}</h5>"
      custom_html << "<ul>"
      popular_store = category[:name]
      merchant_names = category[:store]
      p category[:name]
      p category[:store]
      #popular_merchant_names = ProductCategory.where(name: merchant_names, popular: true).map(&:name)
      merchant_by_names = ProductCategory.get_merchant_by_names(popular_store, merchant_names)
      merchant_names.each do |merchant_name|
        if per_col_count <= loop_count
          if current_alphabet
            custom_html << "</div>" 
            current_alphabet = nil
          end
          custom_html << "</ul>"
          
          custom_html << "</div>" #close existing col-2
          custom_html << "<div class='col-2'>"          
          custom_html << "<ul>"
          loop_count = 0
        end
        loop_count += 1
        custom_html << '<li>'
        merchant = merchant_by_names[merchant_name]
        if merchant
          @advertiser = merchant
          @coupons = @advertiser.unexpired_coupons
          merchant_name = merchant.name.titleize
          if merchant_name.include? "Nhl"
            merchant_name = merchant_name.gsub("Nhl", "NHL")
          end
          if merchant_name.include? "Nba"
            merchant_name = merchant_name.gsub("Nba", "NBA")
          end
          if @coupons.present?
            custom_html << "<a class= 'popular-store' href='#{merchant.base_tracking_url}' data-reveal-id='coupons_cashback_#{merchant.advertiser_id}' data-animation='none'>"
            custom_html << "#{merchant_name}"
            custom_html << '</a>'
          else
            custom_html << "<a class= 'popular-store' href='#{merchant.base_tracking_url}' data-reveal-id='no_coupon_code_#{merchant.advertiser_id}' data-animation='none'>"
            custom_html << "#{merchant_name}"
            custom_html << '</a>'
            
          end
        else
          custom_html << '<a href="#" data-reveal-id="no_coupon_code" data-animation="none">'
          custom_html << "#{merchant_name}"
          custom_html << '</a>'
        end
        custom_html << '</li>'
      end
      custom_html << "</ul>"
      
    end
    custom_html << "</div>" if current_alphabet
    custom_html << "</div>"
    custom_html.join("").html_safe
  end
  
  def flash_message
    message = ""
    [:notice, :alert, :success, :error, :warning, :information, :confirm].each do |type| 
      if(!flash[type].blank?)
        return {
          text: flash[type],
          type: ((type == :notice) ? 'information' : type)
        }
      end
    end
    return nil;
  end
  
  def most_popular_stores_footer_test
    popular = ProductCategory.where(popular: true).order(name: :asc)
    mps_array = []
    popular.each do |pc|
      if pc.hp_stores.present?
        temp_array = []
        pc.hp_stores.each do |pc_hp_store|
          temp_array << pc_hp_store.advertiser.name
        end
        mps_array << {name: pc.name, store: temp_array}
      end
    end
#    categories = mps_array.keys.sort
#    categories = ProductCategory.where(popular: true).order(:name).map(&:name)
    #mps_array = mps_array.sort
    current_alphabet = ''
    custom_html = []
    custom_html << "<div class='col-2'>"
    current_alphabet = nil
    loop_count = 0
    per_col_count = HpStoreProductCategory.count/6
    previous = nil
    b = false
    mps_array.each do |category|      
      unless category[:name][0] == current_alphabet
        custom_html << "</div>" if current_alphabet
        current_alphabet = category[:name][0]
        if previous != current_alphabet
          custom_html << "<div class='list-#{current_alphabet.downcase}'>"
          previous = current_alphabet
          b = true
        end
      end
      custom_html << "<h5>#{category[:name]}</h5>"
      custom_html << "<ul>"
      merchant_names = category[:store]
      merchant_by_names = ProductCategory.get_merchant_by_names(merchant_names)
      merchant_names.each do |merchant_name|
        if per_col_count <= loop_count
          if current_alphabet
            if b
              custom_html << "</div>" 
              current_alphabet = nil
              b = false
            end
          end
          custom_html << "</ul>"
          
          custom_html << "</div>" #close existing col-2
          custom_html << "<div class='col-2'>"          
          custom_html << "<ul>"
          loop_count = 0
        end
        loop_count += 1
        custom_html << '<li>'
        merchant = merchant_by_names[merchant_name]
        if merchant
          @advertiser = merchant.class.name.constantize.where("advertiser_id =?", merchant.advertiser_id).first
          @coupons = @advertiser.coupons.where(['expires_at IS NULL or expires_at >= ?', Date.today])
          merchant_name = merchant.name.titleize
          if merchant_name.include? "Nhl"
            merchant_name = merchant_name.gsub("Nhl", "NHL")
          end
          if merchant_name.include? "Nba"
            merchant_name = merchant_name.gsub("Nba", "NBA")
          end
          if @coupons.present?
            custom_html << '<a href="#">'
            custom_html << "#{merchant_name}"
            custom_html << '</a>'
          else
            custom_html << '<a href = "#">'
            custom_html << "#{merchant_name}"
            custom_html << '</a>'
            
          end
        else
          custom_html << '<a href="#">'
          custom_html << "#{merchant_name}"
          custom_html << '</a>'
        end
        custom_html << '</li>'
      end
      custom_html << "</ul>"
      
    end
    custom_html << "</div>" if current_alphabet
    custom_html << "</div>"
    
    custom_html.join("").html_safe
  end
end
