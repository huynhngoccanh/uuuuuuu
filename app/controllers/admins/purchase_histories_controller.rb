class Admins::PurchaseHistoriesController < Admins::ApplicationController
  def index 
    @purchase_histories=PurchaseHistory.all
  end

  def show
    @items= PurchaseHistory.find(params[:id]).items
  end
end
