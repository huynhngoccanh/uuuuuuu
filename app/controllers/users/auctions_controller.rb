class Users::AuctionsController < ApplicationController
  before_filter :authenticate_user!, :except => :coupons
  layout 'ubitru'

  before_filter :temp_flash_for_service_auction, :only => 'service'

  def index
    session[:finished_auctions] = nil #for destroying notification in the account bar
    list
  end

  def in_progress
    list [:in_progress], 50
  end

  def finished
    list [:finished], 50
  end

  def unconfirmed
    list [:unconfirmed], 50
  end

  def show
    @auction = current_user.auctions.find(params[:id])

    if @auction.resolved? && @auction.winners.count > 0
      @winning_bids = @auction.winning_bids.includes(:vendor)
    else
      @bids = @auction.bids.includes(:vendor).limit(@auction.max_vendors)
    end
    @auction_images = @auction.auction_images
  end

  def print_offer
    @auction = current_user.auctions.find(params[:id])
    @offer = @auction.offers.find(params[:offer_id])
    @title = "MuddleMe offer: #{@offer.name}"
    render :layout => "print"
  end

  def coupons
    raise ActionController::RoutingError.new('Not Found') unless ['cj', 'avant', 'linkshare', 'pj', 'ir'].include?(params[:type])
    begin
      @offer = current_user.send("#{params[:type]}_offers").find(params[:id])
    rescue StandardError # todo stub
      #advertiser = params[:type] == 'cj' ? CjAdvertiser.find_by_advertiser_id(params[:id]) : (params[:type] == 'linkshare' ? LinkshareAdvertiser.find_by_advertiser_id(params[:id]) : (params[:type] == 'avant' ? AvantAdvertiser.find_by_advertiser_id(params[:id]) : PjAdvertiser.find_by_advertiser_id(params[:id])))
      case params[:type]
        when "cj"
          advertiser  = CjAdvertiser.find_by_advertiser_id(params[:id])
        when "linkshare"
          advertiser = LinkshareAdvertiser.find_by_advertiser_id(params[:id])
        when "avant"
          advertiser = AvantAdvertiser.find_by_advertiser_id(params[:id])
        when "pj"
          advertiser = PjAdvertiser.find_by_advertiser_id(params[:id])
        when "ir"
          advertiser = IrAdvertiser.find_by_advertiser_id(params[:id])
      end
      p advertiser
      @offer = Object.new
      @offer.class.module_eval { attr_accessor :advertiser }
      @offer.advertiser = advertiser
    end
    render :layout => 'popup'
  end

  def check_offers
    @auction = current_user.auctions.find(params[:id])
  end

  def resolve
    @auction = current_user.auctions.find(params[:id])
    @auction.resolve_auction true

    if @auction.winners.count > 0
      @winning_bids = @auction.winning_bids.includes(:vendor)
    else
      @bids = @auction.bids.includes(:vendor).paginate(:page => params[:page], :per_page => 10)
    end

    @auction_images = @auction.auction_images

    render 'show'
  end

  def product
    if session[:auction_params].blank? && session[:auction_has_images].blank?
      current_user.auction_images.destroy_all
    end
    @auction = Auction.new((session[:auction_params] || {}).merge({:user_id => current_user.id}))
    @auction.product_auction = true
  end

  def service
    if session[:auction_params].blank? && session[:auction_has_images].blank?
      current_user.auction_images.destroy_all
    end
    @auction = Auction.new((session[:auction_params] || {}).merge({:user_id => current_user.id}))
    @auction.product_auction = false
  end

  def validate
    @auction = current_user.auctions.build(params[:auction])
    if @auction.valid?
      session[:auction_params] = params[:auction]
      redirect_to :action => 'confirm'
    else
      render @auction.product_auction? ? 'product' : 'service'
    end
  end

  def confirm
    @auction = current_user.auctions.build(session[:auction_params])
    @auction_images = current_user.auction_images
  end

  def cancel
    session[:auction_params] = nil
    session[:auction_has_images] = nil
    current_user.auction_images.destroy_all
    redirect_to url_for(:action => 'index'), :notice => 'Canceled auction creation.'
  end

  def create
    #cancel clicked
    if params[:cancel]
      session[:auction_params] = nil
      session[:auction_has_images] = nil
      current_user.auction_images.destroy_all
      redirect_to url_for(:action => 'index'), :notice => 'Canceled auction creation.'
      return
    end


    if params[:use_default_address] == 'yes'
      @auction = current_user.auctions.build(session[:auction_params])
    else
      @auction = current_user.auctions.build(session[:auction_params].merge({
                                                                                :auction_address_attributes => params[:auction_address]}))
      @auction.auction_address.auction = @auction
    end
    @auction.auction_images = current_user.auction_images

    if @auction.save
      session[:auction_params] = nil
      session[:auction_has_images] = nil
      @auction.delay_fetch_affiliate_offers
      redirect_to :action => 'create_success', :id => @auction
    else
      if @auction.auction_address && !@auction.auction_address.valid?
        render :confirm
      else
        render @auction.product_auction? ? 'product' : 'service'
      end
    end
  end

  def create_success
    @auction = current_user.auctions.find(params[:id])
  end

  def update
    @auction = current_user.auctions.find(params[:id])

    if @auction.update_attributes(params[:auction])
      redirect_to @auction, :notice => 'Auction was successfully updated.'
    else
      render :action => "edit"
    end
  end

  def upload_image
    @auction_image = AuctionImage.new(params[:auction_image])
    @auction_image.user = current_user
    if @auction_image.save
      session[:auction_has_images] = true;
      respond_to do |format|
        format.html {
          render :json => [@auction_image.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json {
          render :json => [@auction_image.to_jq_upload].to_json
        }
      end
    else
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end

  def uploaded_images
    render :json => current_user.auction_images.collect { |i| i.to_jq_upload }.to_json
  end

  def outcome
    @auction = current_user.auctions.find(params[:id])
    if @auction.outcome.nil? || @auction.status != 'unconfirmed'
      redirect_to @auction
      return
    end
    @outcome = @auction.outcome
    @preaccepted_vendor_outcome = @outcome.vendor_outcomes.find_by_auto_accepted(true)
    if !@preaccepted_vendor_outcome.blank?
      @outcome.purchase_made = true
      @outcome.vendor_ids = [@preaccepted_vendor_outcome.vendor_id]
    end
    @winning_bids = @auction.winning_bids.includes(:vendor)
  end

  def update_outcome
    @auction = current_user.auctions.find(params[:id])
    if @auction.outcome.nil? || @auction.status != 'unconfirmed'
      redirect_to @auction
      return
    end
    @outcome = @auction.outcome
    vendor_ids = params[:outcome].delete :vendor_ids
    @outcome.attributes = params[:outcome]
    if @outcome.purchase_made
      @outcome.vendor_ids = (@outcome.vendor_ids + vendor_ids.to_a).uniq
    end
    @outcome.confirmed_at = Time.now
    if @outcome.save
      if @outcome.auction.errors[:status].blank?
        vendor_outcome = @outcome.vendor_outcomes.where('accepted IS NULL').first
        unless vendor_outcome.nil?
          if vendor_outcome.auto_accepted
            vendor_outcome.update_attribute :accepted, true
          else
            AuctionsMailer.delay.vendor_confirm_outcome(@auction, vendor_outcome.vendor) if EmailContent.vendor_confirm_outcome_mail?
          end
        end
        Admins::AuctionsMailer.delay.user_provide_auction_outcome(@auction, @outcome) unless @outcome.comment.blank? #send mail to support only if comment is not blank
        redirect_to @auction, :notice => "Thank you for providing outcome for the auction."
      else
        alert = "The deadline for confirming the outcome of this auction"
        alert += " expired #{view_context.format_datetime(@auction.end_time + Auction::CANT_CONFIRM_AFTER)}"
        redirect_to @auction, :alert => alert
      end
    else
      @winning_bids = @auction.winning_bids.includes(:vendor)
      render :action => "outcome"
    end
  end

  private

  def list types=[:in_progress, :unconfirmed, :finished], per_page=10
    sort_by = ['id', 'name', 'product_auction', 'max_vendors', 'budget', 'end_time', 'category']

    where_conds = {
        :in_progress => 'auctions.end_time >= UTC_TIMESTAMP() ',
        :finished => 'auctions.end_time < UTC_TIMESTAMP() ',
        :unconfirmed => 'auctions.status = "unconfirmed" ',
    }

    types.each do |type|
      params[:"#{type}_order"] = 'id' if params[:"#{type}_order"].blank?
      dir = instance_variable_set "@#{type}_dir", :DESC
      if params[:"#{type}_order"] && sort_by.include?(params[:"#{type}_order"])
        instance_variable_set "@#{type}_order", params[:"#{type}_order"]
        instance_variable_set "@#{type}_order_str", 'auctions.id' if params[:"#{type}_order"] == 'id'
        instance_variable_set "@#{type}_order_str", '!product_auction' if params[:"#{type}_order"] == 'product_auction'
        instance_variable_set "@#{type}_order_str", 'IF(auctions.product_auction, product_categories.name, service_categories.name)' if params[:"#{type}_order"] == 'category'
      end
      ord = instance_variable_get "@#{type}_order"
      ord_str = instance_variable_get "@#{type}_order_str"
      dir = instance_variable_set "@#{type}_dir", params[:"#{type}_dir"] == 'DESC' ? :DESC : :ASC unless params[:"#{type}_dir"].blank?


      list = current_user.auctions.where(where_conds[type]).includes(:service_category, :product_category, :outcome).
          order("#{ord_str || ord} #{dir}").paginate(:page => params[:"#{type}_page"], :per_page => per_page)
      instance_variable_set("@auctions_#{type}", list)
    end
  end

  def temp_flash_for_service_auction
    flash.now[:warning] = "Service auction bidding is currently only active for the Greater Boston, MA area. More merchants and markets coming soon!"
  end
end
