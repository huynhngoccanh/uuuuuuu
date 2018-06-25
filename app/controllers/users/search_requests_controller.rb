class Users::SearchRequestsController < ApplicationController
  before_filter :authenticate_user!

  layout "ubitru"
  def index
    list
  end

  def show
    @search_request = current_user.search_intents.find(params[:id])
    @search_merchants = @search_request.merchants
    @user_pending_earnings = @search_request.merchants.select('SUM(user_money) as user_money').where(:active => true).where("type = '#{Search::SoleoMerchant.name}' or type = '#{Search::LocalMerchant.name}'").first.user_money
    @user_earnings = @search_request.user_earnings || 0
    if @user_earnings > 0
      @target_commission = Search::AvantCommission.where(:search_intent_id_received => @search_request.id).order(:created_at => :desc).first
      @target_commission = Search::CjCommission.where(:search_intent_id_received => @search_request.id).order(:created_at => :desc).first if @target_commission.nil?
      @target_commission = Search::LinkshareCommission.where(:search_intent_id_received => @search_request.id).order(:created_at => :desc).first if @target_commission.nil?
      @target_commission = Search::PjCommission.where(:search_intent_id_received => @search_request.id).order(:created_at => :desc).first if @target_commission.nil?
      #@merchant_with_commission = @target_commission.is_a?(Search::CjCommission) ? @target_commission.cj_merchant : (@target_commission.is_a?(Search::AvantCommission) ? @target_commission.avant_merchant : @target_commission.linkshare_merchant)
      @merchant_with_commission = @merchant_with_commission = @target_commission.is_a?(Search::CjCommission) ? @target_commission.cj_merchant : (@target_commission.is_a?(Search::AvantCommission) ? @target_commission.avant_merchant : (@target_commission.is_a?(Search::LinkshareCommission) ? @target_commission.linkshare_merchant : @target_commission.pj_merchant))
      @advertiser_with_commission = @merchant_with_commission.advertiser
    end
  end

  def outcome
    @search_request = current_user.search_intents.find(params[:id])
    @search_merchants = @search_request.merchants
    @outcome = Search::IntentOutcome.new
  end

  def update_outcome
    @search_request = current_user.search_intents.find(params[:id])
    @outcome = @search_request.build_intent_outcome(params[:outcome])
    if @outcome.save
      @search_request.status = Search::Intent::STATUSES[1] # confirmed
      @search_request.save
      begin
        SearchMailer.soleo_pending_outcome_provided(@search_request, @outcome).deliver
      rescue StandardError => e
        logger.info e.message
      end
      redirect_to "/search_requests/#{@search_request.id}", :notice => 'Thank you for providing outcome for your intent.'
    else
      redirect_to "/search_requests/#{@search_request.id}/outcome", :alert => @outcome.errors.full_messages.join(' ')
    end
  end

  def list types=[:in_progress, :unconfirmed, :finished], per_page=10
    sort_by = ['search_intents.id', 'search', 'merchants_count', 'ends_in']

    ends_in_sql = '(7 - DATEDIFF(NOW(), search_intents.created_at))'
    where_conds = {
        :in_progress => "search_intents.status = 'active' and #{ends_in_sql} > 0",
        :unconfirmed => "search_intents.status = 'active' and has_active_service_merchants = true and #{ends_in_sql} < 1",
        :finished => "search_intents.status = 'confirmed'"
    }

    types.each do |type|
      params[:"#{type}_order"] = 'search_intents.id' if params[:"#{type}_order"].blank?
      dir = instance_variable_set "@#{type}_dir", :DESC
      if params[:"#{type}_order"] && sort_by.include?(params[:"#{type}_order"])
        instance_variable_set "@#{type}_order", params[:"#{type}_order"]
        instance_variable_set "@#{type}_order_str", 'id' if params[:"#{type}_order"] == 'id'
      end
      ord = instance_variable_get "@#{type}_order"
      ord_str = instance_variable_get "@#{type}_order_str"
      dir = instance_variable_set "@#{type}_dir", params[:"#{type}_dir"] == 'DESC' ? :DESC : :ASC unless params[:"#{type}_dir"].blank?
      list = current_user.search_intents.select("search_intents.id, search, has_active_service_merchants, status, search_intents.created_at, search_intents.updated_at, count(*) as merchants_count, #{ends_in_sql} AS ends_in").joins(:merchants).where(where_conds[type]).group('search_intents.id').order("#{ord_str || ord} #{dir}").paginate(:page => params[:"#{type}_page"], :per_page => per_page)
      instance_variable_set("@search_requests_#{type}", list)
    end
  end
end
