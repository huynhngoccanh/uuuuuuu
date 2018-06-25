class Vendors::AuctionsController < ApplicationController
  before_filter :authenticate_vendor!
  
  before_filter :disallow_unconfirmed, :only=>['edit_bid', 'new_bid','create_bid','update_bid']
  
  def index
    session[:new_leads] = nil #for destroing notification in the account bar
    @bid = Bid.new #for making new bids popup form
    list
  end
  
  def search
    list([:recommended, :all_unfinished, :product_unfinished , :service_unfinished], 50)
  end
  
  def show
    @auction = Auction.find(params[:id], :include=>{:outcome=>:vendors})
    
    #redirect to vendor confirmation page if pending outcome from this vendor
    if !@auction.outcome.nil? && @auction.outcome.vendors.include?(current_vendor) && 
      (vendor_outcome = @auction.outcome.vendor_outcomes.find_by_vendor_id(current_vendor.id)) &&
      vendor_outcome.accepted.nil?
      
      redirect_to :action=>:outcome, :id=>@auction
      return
    end
    
    if @auction.resolved? && @auction.winners.include?(current_vendor)
      @winning_bids = @auction.winning_bids.includes(:vendor)
    else
      @bids = @auction.bids.paginate(:page=>params[:page], :per_page=>10)
    end
    @auction_images = @auction.auction_images

    @bidding_campaign = Campaign.joins(:auctions).where('campaigns.vendor_id' => current_vendor.id, 'bids.auction_id' => @auction.id).first
  end
  
  def bid
    @type = :bid
    list([@type], 50)
    render 'one_table'
  end
  
  def recommended
    @type = :recommended
    list([@type], 50)
    render 'one_table'
  end
  
  def latest
    @type = :latest
    list([@type], 50)
    render 'one_table'
  end
  
  def finished
    @type = :finished
    list([@type], 50)
    render 'one_table'
  end
  
  def saved
    @type = :saved
    list([@type], 50)
    render 'one_table'
  end

  def won
    @type = :won
    respond_to do |format|
      format.html do
        list([@type], 50)
        render 'one_table'
      end
      format.js do
        list([@type], 50)
        render 'one_table'
      end
      format.csv do
        list([@type], -1)
        csv_string = CSV.generate do |csv|
          csv << csv_export_columns.map{|col| col.second}
          @auctions_won.each do |a|
            csv << csv_export_columns.map{|col| view_context.auction_attribute(a, col.first)}
          end
        end
        send_data csv_string, :filename => "Your Ubitru Leads #{Time.now.strftime('%m/%d/%Y %R')}.csv"
      end
    end
  end
  
  def user
    @auction = Auction.find(params[:id])
    @type = :user
    list([@type], 5)
    render 'user'
  end
  
  def edit_bid
    @auction = Auction.find(params[:id])
    @bid = @auction.bids.where(:vendor_id=>current_vendor.id).first
  end
  
  def new_bid
    @auction = Auction.find(params[:id])
    @bid = @auction.bids.build()
    @bid.vendor_id = current_vendor.id
  end
  
  def create_bid
    @auction = Auction.find(params[:id])
    @bid = @auction.bids.build(:max_value=>params[:bid][:max_value])
    @bid.vendor_id = current_vendor.id

    if params[:bid][:offer_attributes]
      @offer = current_vendor.offers.build(params[:bid][:offer_attributes])
      @offer.product_offer = @auction.product_auction
      @offer.offer_images = current_vendor.offer_images
      @bid.offer = @offer
      unless @offer.save
        @expand_form = true
        return
      end
    else
      @bid.offer_id = params[:bid][:offer_id]
    end

    if @bid.save
      @bid_is_valid = true
      flash[:notice] = 'You have BID in an auction.'
    end
  end
  
  def update_bid
    @auction = Auction.find(params[:id])
    @bid = @auction.bids.where(:vendor_id=>current_vendor.id).first
    @bid.max_value = params[:bid][:max_value]

    if params[:bid][:offer_attributes]
      @offer = current_vendor.offers.build(params[:bid][:offer_attributes])
      @offer.product_offer = @auction.product_auction
      @offer.offer_images = current_vendor.offer_images
      @bid.offer = @offer
      unless @offer.save
        @expand_form = true
        return
      end
    else
      @bid.offer_id = params[:bid][:offer_id]
    end
    
    @bid.campaign = nil
    if @bid.save
      @bid_is_valid = true
      flash[:notice] = 'You have changed your BID in an auction.'
    end
  end
  
  def save
    @auction = Auction.find(params[:id])
    unless current_vendor.saved_auctions.include? @auction
      current_vendor.saved_auctions << @auction
    end
    flash[:notice] = "You have saved the auction: #{@auction.name}."
  end
  
  def unsave
    @auction = Auction.find(params[:id])
    if current_vendor.saved_auctions.include? @auction
      current_vendor.saved_auctions.delete(@auction)
    end
    flash[:notice] = "You removed the auction: #{@auction.name} from your saved auctions."
  end
  
  def outcome
    @auction = Auction.find(params[:id])
    if @auction.outcome.nil? || !@auction.outcome.vendors.include?(current_vendor)
      redirect_to @auction
      return
    end
    @vendor_outcome = @auction.outcome.vendor_outcomes.find_by_vendor_id current_vendor.id
  end
  
  def update_outcome
    @auction = Auction.find(params[:id])
    if @auction.outcome.nil? || !@auction.outcome.vendors.include?(current_vendor)
      redirect_to @auction
      return
    end
    @vendor_outcome = @auction.outcome.vendor_outcomes.find_by_vendor_id current_vendor.id
    @vendor_outcome.attributes = params[:vendor_outcome]

    if @vendor_outcome.save
      Admins::AuctionsMailer.delay.vendor_confirm_auction_outcome(@auction, @vendor_outcome) unless @vendor_outcome.comment.blank? #send mail to support only if comment is not blank
      redirect_to @auction, :notice => "Thank you for providing feedback for this auction."
    else
      render :action => "update_outcome"
    end
  end

  def preview_profile
    @auction = Auction.find(params[:id], :include=>{:outcome=>:vendors})
  end

  private
  
  def list types=[:bid, :recommended, :latest, :finished , :saved], per_page=10
    vendor_auction_list per_page, types
  end
  
  def csv_export_columns
    [ 
      ["user.first_name", "First name"],
      ["user.last_name", "Last name"],
      ["user.email", "Email address"],
      ["user.city", "City"],
      ["user.zip_code", "ZIP"],
      ["user.phone", "Phone number"],
      ["user.sex", "Gender"],
      ["user.age_range", "Age range"],
      ["score", "MM score"],
      ["number", "Auction number "],
      ["name", "Auction description / Project name"],
      ["category", "Category"],
      ["desired_time_range", "Desired time of service"],
      ["contact_time_range", "Best contact time"],
      ["extra_info", "Additional info"],
      ["created_at", "Started at "],
      ["end_time", "Ended at"],
      ["vendor_bid", "Bid ammount"],
      ["winning_bids_count", "Number of winning vendors"],
    ]
  end
end
