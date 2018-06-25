class VendorsController < ApplicationController
  
  def index
    
  end

  def dashboard
    @bid = Bid.new #for making new bids popup form
    vendor_auction_list 3, [:recommended, :latest, :bid, :saved]
    
    conv_percent_sql = 'count(search_intent_outcomes.id)/count(search_merchants.id)'
    joins_sql = 'LEFT JOIN search_intent_outcomes ON (search_intent_outcomes.intent_id = search_merchants.intent_id and search_intent_outcomes.merchant_id = search_merchants.id and search_intent_outcomes.purchase_made=1)'

    @best_campaigns = current_vendor.campaigns.where('campaigns.status != "deleted"').
                   select("campaigns.*, 
                          count(search_merchants.id) AS impressions,
                          #{conv_percent_sql} AS conversion_percent").
                   group('campaigns.id').
                   joins('LEFT JOIN search_merchants ON (search_merchants.db_id = campaigns.id and search_merchants.type = "' + Search::LocalMerchant.name + '") ' + joins_sql).
                   order("#{conv_percent_sql} DESC").limit(3)

    @best_offers = current_vendor.offers.where(:is_deleted=>false).
        select("offers.*,
                          count(search_merchants.id) AS impressions,
                          #{conv_percent_sql} AS conversion_percent").
        group('offers.id').
        joins('LEFT JOIN search_merchants ON (search_merchants.other_db_id = offers.id and search_merchants.type = "' + Search::LocalMerchant.name + '") ' + joins_sql).
        order("#{conv_percent_sql} DESC").limit(3)
  end

  def categories
    @vendor = current_vendor
  end

  def update
    @vendor = current_vendor
    @vendor.dont_require_password = true

    if @vendor.update_attributes(params[:vendor])
      redirect_to url_for(:action => :categories), :notice => 'Company Details were successfully updated.'
    else
      flash.now[:alert] = 'There where errors while updating your profile'
      render :action => :categories
    end

  end
  
  def what_is_muddle_me
    
  end
  
  def how_it_works
    
  end

  def terms_and_conditions
    render "users/terms_and_conditions"
  end

  def privacy_policy
    render "users/privacy_policy"
  end

end
