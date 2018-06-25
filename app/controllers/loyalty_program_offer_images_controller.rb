class LoyaltyProgramOfferImagesController < ApplicationController
  before_action :set_loyalty_program_offer_image, only: [:show, :edit, :update, :destroy]

  # GET /loyalty_program_offer_images
  def index
    @loyalty_program_offer_images = LoyaltyProgramOfferImage.all
  end

  # GET /loyalty_program_offer_images/1
  def show
  end

  # GET /loyalty_program_offer_images/new
  def new
    @loyalty_program_offer_image = LoyaltyProgramOfferImage.new
  end

  # GET /loyalty_program_offer_images/1/edit
  def edit
  end

  # POST /loyalty_program_offer_images
  def create
    @loyalty_program_offer_image = LoyaltyProgramOfferImage.new(loyalty_program_offer_image_params)

    if @loyalty_program_offer_image.save
      redirect_to @loyalty_program_offer_image, notice: 'Loyalty program offer image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /loyalty_program_offer_images/1
  def update
    if @loyalty_program_offer_image.update(loyalty_program_offer_image_params)
      redirect_to @loyalty_program_offer_image, notice: 'Loyalty program offer image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /loyalty_program_offer_images/1
  def destroy
    @loyalty_program_offer_image.destroy
    redirect_to loyalty_program_offer_images_url, notice: 'Loyalty program offer image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loyalty_program_offer_image
      @loyalty_program_offer_image = LoyaltyProgramOfferImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def loyalty_program_offer_image_params
      params.require(:loyalty_program_offer_image).permit(:loyalty_program_id, :loyalty_program_offer, :image_updated_at, :image_file_name, :image_content_type, :image_file_size)
    end
end
