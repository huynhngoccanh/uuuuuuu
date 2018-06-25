class Vendors::CampaignsController < ApplicationController
  before_filter :disallow_unconfirmed, :except => ['index']

  def index
    Campaign.check_stop_dates_and_update
    @campaigns_order = params[:campaigns_order] || 'campaigns.name'
    @campaigns_dir = params[:campaigns_dir] == 'DESC' ? :DESC : :ASC

    @campaigns_order = 'campaigns.budget - total_spent' if @campaigns_order == 'budget_left'

    @campaigns = current_vendor.campaigns.where('campaigns.status != "deleted"').
        joins('LEFT JOIN search_merchants ON (search_merchants.db_id = campaigns.id and search_merchants.type = "' + Search::LocalMerchant.name + '")
        LEFT JOIN search_intent_outcomes ON (search_intent_outcomes.intent_id = search_merchants.intent_id and search_intent_outcomes.merchant_id = search_merchants.id and search_intent_outcomes.purchase_made=1)').
        group('campaigns.id').
        select('campaigns.*, count(search_merchants.id) AS searches_count, count(search_intent_outcomes.id) as searches_won_count, ' +
                   'count(search_intent_outcomes.id)/count(search_merchants.id) AS searches_won_ratio').
        order("#{@campaigns_order} #{@campaigns_dir}").paginate(:page => params[:campaigns_page], :per_page => 30)

  end

  def product
    @campaign = current_vendor.campaigns.build()
    @campaign.product_campaign = true
  #  @campaign.campaign_type = "product"
    check_offers("product")
  end

  def service
    @campaign = current_vendor.campaigns.build()
    @campaign.product_campaign = false
   # @campaign.campaign_type = "service"
    check_offers("service")
  end
  
  def create
    @campaign = current_vendor.campaigns.build(params[:campaign])

    if @campaign.save
      redirect_to(campaigns_path, :notice => 'Campaign was successfully created.')
    else
      render :action => @campaign.product_campaign ? "product" : "service"
    end
  end

  def edit
    @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])
  end

  def finished_auctions
    @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])

    @auctions_order = params[:auctions_order] || 'auctions.id'
    @auctions_dir = params[:auctions_dir] == 'DESC' ? :DESC : :ASC

    @auctions = @campaign.auctions.where('auctions.end_time < ?', Time.now).
        joins(:user).
        order("#{@auctions_order} #{@auctions_dir}").paginate(:page => params[:campaign_auctions_page], :per_page => 30)
  end

  def update
    @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])

    respond_to do |format|
      if @campaign.update_attributes(params[:campaign])
        format.html { redirect_to(edit_campaign_path(@campaign), :notice => 'Campaign was successfully updated.') }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @campaign.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])

    respond_to do |format|
      if @campaign.update_attribute :status, 'deleted'
        notice = "Campaign was deleted successfully."
        format.html { redirect_to campaigns_path, :notice => notice }
        format.js {
          flash.now[:notice] = notice
          render '_delete_success'
        }
        format.json { render :json => @campaign }
      else
        alert = "Unable to delete campaign."
        format.html { redirect_to campaigns_path, :alert => alert }
        format.js {
          flash.now[:alert] = alert
          render 'application/show_flash'
        }
        format.json { render :json => @campaign, :status => 406 }
      end
    end

  end

  def pause
    @campaign = @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])
    @campaign.status = 'stopped'

    respond_to do |format|
      if @campaign.save
        notice = 'Campaign paused.'
        format.html { redirect_to(:back, :notice => notice) }
        format.js {
          flash.now[:notice] = notice
          render 'application/show_flash'
        }
      else
        alert = 'Error pausing campaign.'
        format.html { redirect_to(:back, :alert => alert) }
        format.js {
          flash.now[:alert] = alert
          render 'application/show_flash'
        }
      end
    end

  end

  def resume
    @campaign = @campaign = current_vendor.campaigns.where('status != "deleted"').
        find(params[:id])
    @campaign.status = 'running'
    if !@campaign.stop_at.nil? && @campaign.stop_at < Time.now
      @campaign.stop_at = nil
    end

    respond_to do |format|
      if @campaign.save
        notice = 'Campaign resumed.'
        format.html { redirect_to(:back, :notice => notice) }
        format.js {
          flash.now[:notice] = notice
          render 'application/show_flash'
        }
      else
        alert = 'Error resuming campaign.'
        format.html { redirect_to(:back, :alert => alert) }
        format.js {
          flash.now[:alert] = alert
          render 'application/show_flash'
        }
      end
    end

  end

  private

   def check_offers(type)
    if type == "product" && current_vendor.offers.where(:product_offer => true).blank?
      warning = "You don't have any product offers. You can't run a campaign without any offers. <a href=\"#{product_new_offer_path}\" title=\"Create an offer\">Click here</a> to create an offer."
      flash.now[:warning] = warning.html_safe
    elsif type == "service" && current_vendor.offers.where(:product_offer => false).blank?
      warning = "You don't have any service offers. You can't run a campaign without any offers. <a href=\"#{service_new_offer_path}\" title=\"Create an offer\">Click here</a> to create an offer."
      flash.now[:warning] = warning.html_safe
    end
  end

end