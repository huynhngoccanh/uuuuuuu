class LoyaltyProgramOffersController < ApplicationController
  before_action :set_loyalty_program_offer, only: [:show, :edit, :update, :destroy]

  # GET /loyalty_program_offers
  def index
    @loyalty_program_offers = LoyaltyProgramOffer.all
  end

  # GET /loyalty_program_offers/1
  def show
  end

  # GET /loyalty_program_offers/new
  def new
    @loyalty_program_offer = LoyaltyProgramOffer.new
  end

  # GET /loyalty_program_offers/1/edit
  def edit
  end

  # POST /loyalty_program_offers
  def create
    @loyalty_program_offer = LoyaltyProgramOffer.new(loyalty_program_offer_params)

    if @loyalty_program_offer.save
      redirect_to @loyalty_program_offer, notice: 'Loyalty program offer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /loyalty_program_offers/1
  def update
    if @loyalty_program_offer.update(loyalty_program_offer_params)
      redirect_to @loyalty_program_offer, notice: 'Loyalty program offer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /loyalty_program_offers/1
  def destroy
    @loyalty_program_offer.destroy
    redirect_to loyalty_program_offers_url, notice: 'Loyalty program offer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loyalty_program_offer
      @loyalty_program_offer = LoyaltyProgramOffer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def loyalty_program_offer_params
      params.require(:loyalty_program_offer).permit(:loyalty_program_id, :name, :coupon_code, :offer_url, :offer_description, :expiration_time, :product_offer, :is_deleted)
    end
end
