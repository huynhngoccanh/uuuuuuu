class Vendors::TrackingEventsController < ApplicationController

  def index
    index_action
    
    @vendor_setting = current_vendor.vendor_setting || current_vendor.build_vendor_setting({
      :auto_confirm_outcomes => current_vendor.auto_confirm_outcomes?,
    })
  end
  
  def create_test
    VendorTrackingEvent.delete_all(:vendor_id=>current_vendor.id, :auction_id=>-1)
    
    Offer.class_eval do
      validates :offer_url, :presence=>true
    end
    
    @testOffer = current_vendor.offers.build({
      :name=>'test',
      :offer_url=>params[:offer][:offer_url]
    })
    
    if @testOffer.valid?
      session[:test_offer_url] = @testOffer.offer_url
      get_test_results
    end
  end
  
  def check_test
    unless session[:test_offer_url].blank?
      @testOffer = current_vendor.offers.build({
        :name=>'test',
        :offer_url=>session[:test_offer_url]
      })
      get_test_results
    end
  end
  
  
  def create
    begin
      Vendor.find(params[:v]).tracking_events.create({
        :auction_id=> params[:a].to_i == -1 ? params[:a] : Auction.find(params[:a]).id,
        :event_type=>params[:event_type]
      })
    rescue     
      #TODO log the error here
      if params[:eventy_type] != 'clicked'
        render :text=>'', :status=>500
        return
      end
    end
    
    if params[:redirect_to]
      redirect_to params[:redirect_to]
    else
      render :text => '' 
    end
  end
  
  def update_settings
    @vendor_setting = current_vendor.vendor_setting || current_vendor.build_vendor_setting
    @vendor_setting.attributes = params[:vendor_setting]
    if @vendor_setting.save
      redirect_to url_for(:action=>'index'), :notice => 'Your settings were successfully saved.'
    else
      index_action
      render :action => "index"
    end
  end
  
  private
  
  def index_action
    Offer.class_eval do
      validates :offer_url, :presence=>true
    end
    
    unless session[:test_offer_url].blank?
      @testOffer = current_vendor.offers.build({
        :name=>'test',
        :offer_url=>session[:test_offer_url]
      })
      get_test_results
    end
  end
  
  def get_test_results
    @clicked_count = current_vendor.tracking_events.where(:auction_id=>-1, :event_type=>'clicked').count
    @visited_count = current_vendor.tracking_events.where(:auction_id=>-1, :event_type=>'visited').count
    @converted_count = current_vendor.tracking_events.where(:auction_id=>-1, :event_type=>'converted').count
  end
end
