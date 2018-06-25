class Vendors::OfferImagesController < ApplicationController
  def destroy
    @offer_image = current_vendor.all_offer_images.find(params[:id])
    @offer_image.destroy
    render :json=>'OK'
  end
end
