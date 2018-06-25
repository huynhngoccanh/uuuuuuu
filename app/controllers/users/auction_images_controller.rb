class Users::AuctionImagesController < ApplicationController
  def destroy
    @auction_image = current_user.auction_images.find(params[:id])
    @auction_image.destroy
    render :json=>'OK'
  end
end
