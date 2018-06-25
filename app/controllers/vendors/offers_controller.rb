class Vendors::OffersController < ApplicationController
  before_filter :disallow_unconfirmed, :except=>['index']
  
  def index
    @offers_order = params[:offers_order] || 'name'
    @offers_dir = params[:offers_dir] == 'DESC' ? :DESC : :ASC
    
    @offers = current_vendor.offers.where(:is_deleted=>false).includes(:bids).
      order("#{@offers_order} #{@offers_dir}").paginate(:page=>params[:offers_page], :per_page=>30)
  end
  
  
  def product
    @offer = current_vendor.offers.build()
    @offer.service_type="product"
    @offer.product_offer=true
    current_vendor.offer_images.destroy_all
  end
  
  def service
    @offer = current_vendor.offers.build()
    @offer.service_type="service"
    @offer.product_offer=false
    current_vendor.offer_images.destroy_all
  end
  
    
  def personal
    if current_vendor.loyalty_program.nil?
      flash[:alert] = "Please select a loyalty program from above before creating a personal offer"
      redirect_to( :action => "product")
    else
    @offer = current_vendor.offers.build()
    @offer.service_type="personal"
    current_vendor.offer_images.destroy_all
    end
  end
  
    
 
  
  def create
    if params[:offer][:service_type] == "personal"

      @offer = current_vendor.offers.build(personal_offer_params)
      if params[:offer][:expiration_time]!=""
         @offer.expiration_time = Date.strptime(params[:offer][:expiration_time], "%m/%d/%Y")
         @offer.dont_require_name=true
      end

               if  params[:images]
                  params[:images].each { |image|
                   @offer.offer_images<<OfferImage.create(image: image)
                  }
                end
      
            if @offer.save

              redirect_to(offers_path, :notice => 'Offer was successfully created.')
            else
      
            if !@offer.offer_images.nil?
               render :action => "personal"
            else
           
              flash[:alert] = "Needs atleast one offer image"
               render :action => "personal"
            end
            end

      
    else
      @offer = current_vendor.offers.build(offer_params)
      
        if  params[:images]
                  params[:images].each { |image|
                   @offer.offer_images<<OfferImage.create(image: image)
                  }
                  
        else
          @offer.dont_require_offer_images=true
        end
      
      
      if params[:offer][:expiration_time]
         @offer.expiration_time = Date.strptime(params[:offer][:expiration_time], "%m/%d/%Y")
      else
         @offer.dont_require_expiration_time=true
      end
      @offer.dont_require_barcode_image=true
      @offer.dont_require_offer_description=true

      
              if @offer.save
                redirect_to(offers_path, :notice => 'Offer was successfully created.')
              else
                render :action => @offer.product_offer ? "product" : "service"
              end
      
    end
    
  
  end 
  
  def edit
    @offer = current_vendor.offers.where(:is_deleted=>false).includes(:bids).
      find(params[:id])
    unless @offer.editable?
      redirect_to offers_path, :alert => "This offer is currently being used in one of your auctions. You can't edit it."
    end
  end
  
  def update
    @offer = @offer = current_vendor.offers.where(:is_deleted=>false).includes(:bids).
      find(params[:id])
    unless @offer.editable?
      redirect_to offers_path, :alert => "This offer is currently being used in one of your auctions. You can't edit it."
      return
    end
 
    respond_to do |format|
      if @offer.update_attributes(params[:offer])
        format.html  { redirect_to(offers_path, :notice => 'Offer was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @offer.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @offer = current_vendor.offers.where(:is_deleted=>false).
      find(params[:id])
    respond_to do |format|
      if @offer.update_attribute :is_deleted, true
        format.json { render :json => @offer }
        format.html { redirect_to offers_path, :notice => "Offer was deleted sucessfully." }
      else
        format.json { render :json => @offer, :status => 406 }
        format.html { redirect_to offers_path, :alert => "Unable to delete offer." }
      end
    end
  end
  
  def upload_image
    @offer_image = current_vendor.offer_images.build(params[:offer_image])
    if @offer_image.save
      respond_to do |format|
        format.html {  
          render :json => [@offer_image.to_jq_upload].to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json {  
          render :json => [@offer_image.to_jq_upload].to_json			
        }
      end
    else 
      render :json => [{:error => "custom_failure"}], :status => 304
    end
  end
  
  def uploaded_images
    @offer = current_vendor.offers.where(:is_deleted=>false).
      find_by_id(params[:id])
    if @offer.blank?
      render :json => current_vendor.offer_images.collect { |i| i.to_jq_upload }.to_json
    else
      render :json => @offer.offer_images.collect { |i| i.to_jq_upload }.to_json
    end
  end
  
  def preview
    @offer = current_vendor.offers.where(:is_deleted=>false).
      find_by_id(params[:id])
    
    if  params[:images]
                  current_vendor.offer_images.destroy_all
                  params[:images].each { |image|
                  current_vendor.offer_images<<OfferImage.create(image: image)
                  }
    end
    
    if @offer.blank?
      if params[:bid] && params[:bid][:offer_attributes]
        @offer = current_vendor.offers.build(params[:bid][:offer_attributes])
      else
        @offer = current_vendor.offers.build(params[:offer])
      end
    end
  end
  
  
  def preview_existing
    @offer = current_vendor.offers.where(:is_deleted=>false).
      find(params[:id])
  end
end


private

def personal_offer_params
    params.require(:offer).permit(:expiration_time, :offer_description, :offer_video, :barcode_image, :service_type, :product_offer)
end

def offer_params
    params.require(:offer).permit(:name, :offer_url, :coupon_code, :expiration_time, :offer_description, :offer_video, :service_type, :product_offer)
end