class Vendors::PersonalOffersController < ApplicationController
  before_filter :disallow_unconfirmed, :except=>['index']
  
  def create
    @personal_offer = current_vendor.personal_offers.build(personal_offer_params)
    @personal_offer.expiration_date = Date.strptime(personal_offer_params[:expiration_date], "%m/%d/%Y")

    if @personal_offer.save
      redirect_to(url_for(:controller => "offers", :action => "personal"), :notice => 'Offer was successfully created.')
    else
      render :action => "personal"
    end
  end 
  
  def show
    @personal_offer=PersonalOffer.find(params[:id])
  end
  
  
  def personal_offer_params
    params.require(:personal_offer).permit(:header, :offer_video, :offer_barcode_image, :expiration_date, :offer_image)
  end
  
  
  def preview
    @offer = current_vendor.offers.where(:is_deleted=>false).
      find_by_id(params[:id])
    if @offer.blank?
      if params[:bid] && params[:bid][:offer_attributes]
        @offer = current_vendor.offers.build(params[:bid][:offer_attributes])
      else
        @offer = current_vendor.offers.build(params[:offer])
      end
    end
  end
  
end