class Vendors::SearchesController < ApplicationController
  before_filter :authenticate_vendor!

  def index
    @date_end = Time.now.to_date
    @date_start = (@date_end - 1.month).at_beginning_of_month
    @searches = Search::Intent.where('DATE(created_at) BETWEEN ? AND ?', @date_start, @date_end).order('created_at desc').paginate(:page => params[:page], :per_page => 10)
  end

  def active
    @searches = Search::Intent.joins(:merchants).where('search_merchants.type = ?', Search::LocalMerchant.name).joins('inner join campaigns on campaigns.id = search_merchants.db_id').where('campaigns.vendor_id = ?', current_vendor.id).order('search_intents.created_at desc').paginate(:page => params[:page], :per_page => 10)
  end

  def lost
    @searches = Search::Intent.joins(:merchants).where('search_merchants.type = ?', Search::LocalMerchant.name).joins('inner join campaigns on campaigns.id = search_merchants.db_id').where('campaigns.vendor_id = ?', current_vendor.id).joins('left join search_intent_outcomes on (search_intent_outcomes.merchant_id = search_merchants.id)').where('search_intent_outcomes.id is null or search_intent_outcomes.purchase_made = 0').order('search_intents.created_at desc').paginate(:page => params[:page], :per_page => 10)
  end

  def won
    @searches = Search::Intent.joins(:merchants).where('search_merchants.type = ?', Search::LocalMerchant.name).joins('inner join campaigns on campaigns.id = search_merchants.db_id').where('campaigns.vendor_id = ?', current_vendor.id).joins('inner join search_intent_outcomes on (search_intent_outcomes.purchase_made = 1 and search_intent_outcomes.merchant_id = search_merchants.id)').order('search_intents.created_at desc').paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @search = Search::Intent.find(params[:id])
    @user = @search.user
    @merchants = Search::Merchant.where('intent_id = ?', @search.id).joins('left join campaigns on campaigns.id = search_merchants.db_id')
  end
end
