
class Admins::AuctionsController < Admins::ApplicationController

  def index
    list [:all, :in_progress, :finished, :confirmation_negative]
  end

  def show
    @auction = Auction.find(params[:id])

    if @auction.resolved? && @auction.winners.count > 0
      @winning_bids = @auction.winning_bids.includes(:vendor)
    else
      @bids = @auction.bids.includes(:vendor).paginate(:page=>params[:page], :per_page=>10)
    end

    @auction_images = @auction.auction_images
  end

  private

  def list types=[:all, :in_progress, :finished, :unconfirmed, :confirmation_negative], per_page=10
    sort_by = ['id', 'product_auction', 'name', 'created_at', 'last_name', 'status', 'bids_count', 'user_earnings']

    where_conds = {
        :in_progress => 'auctions.end_time >= UTC_TIMESTAMP() ',
        :finished => 'auctions.end_time < UTC_TIMESTAMP() ',
        :unconfirmed => 'auctions.status = "unconfirmed" ',
        :confirmation_negative => 'auctions.status = "confirmed" AND auction_outcomes.purchase_made = FALSE'
    }

    types.each do |type|
      params[:"#{type}_order"] = 'id' if params[:"#{type}_order"].blank?
      dir = instance_variable_set "@#{type}_dir", :DESC

      if params[:"#{type}_order"] && sort_by.include?(params[:"#{type}_order"])
        instance_variable_set "@#{type}_order", params[:"#{type}_order"]
        instance_variable_set "@#{type}_order_str", 'auctions.id' if params[:"#{type}_order"] == 'id'
        instance_variable_set "@#{type}_order_str", '!product_auction' if params[:"#{type}_order"] == 'product_auction'
        instance_variable_set "@#{type}_order_str", 'users.last_name' if params[:"#{type}_order"] == 'last_name'
      end
      ord = instance_variable_get "@#{type}_order"
      ord_str = instance_variable_get "@#{type}_order_str"
      dir = instance_variable_set "@#{type}_dir", params[:"#{type}_dir"] == 'DESC' ? :DESC : :ASC unless params[:"#{type}_dir"].blank?

      #list = Auction.where(where_conds[type]).
      #    joins(:bids, :user).group('auctions.id').select('auctions.*, COUNT(*) AS bids_count, users.*').
      #    order("#{ord_str || ord} #{dir}").paginate(:page=>params[:"#{type}_page"], :per_page=>per_page)

   #   list = Auction.where(where_conds[type])
    list = Auction.where(where_conds[type]).eager_load(:outcome)

      list = list.date_filter('created_at', '>=', params[:created_at_from]) unless params[:created_at_from].blank?
      list = list.date_filter('created_at', '<=', params[:created_at_to]) unless params[:created_at_to].blank?
      list = list.date_filter('end_time', '>=', params[:ended_at_from]) unless params[:ended_at_from].blank?
      list = list.date_filter('end_time', '<=', params[:ended_at_to]) unless params[:ended_at_to].blank?

      list = list.search(params[:search]) unless params[:search].blank?

      list = list.includes(:user, :bids, :outcome).
          order("#{ord_str || ord} #{dir}").paginate(:page=>params[:"#{type}_page"], :per_page=>per_page)

      instance_variable_set("@auctions_#{type}", list)
    end
  end
end
