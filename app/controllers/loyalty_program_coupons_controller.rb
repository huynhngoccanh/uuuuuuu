class LoyaltyProgramCouponsController < ApplicationController
  before_action :set_loyalty_program_coupon, only: [:show, :edit, :update, :destroy]

  # GET /loyalty_program_coupons
  def index
    @loyalty_program_coupons = LoyaltyProgramCoupon.all
  end

  # GET /loyalty_program_coupons/1
  def show
  end

  # GET /loyalty_program_coupons/new
  def new
    @loyalty_program_coupon = LoyaltyProgramCoupon.new
  end

  # GET /loyalty_program_coupons/1/edit
  def edit
  end

  # POST /loyalty_program_coupons
  def create
    @loyalty_program_coupon = LoyaltyProgramCoupon.new(loyalty_program_coupon_params)

    if @loyalty_program_coupon.save
      redirect_to @loyalty_program_coupon, notice: 'Loyalty program coupon was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /loyalty_program_coupons/1
  def update
    if @loyalty_program_coupon.update(loyalty_program_coupon_params)
      redirect_to @loyalty_program_coupon, notice: 'Loyalty program coupon was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /loyalty_program_coupons/1
  def destroy
    @loyalty_program_coupon.destroy
    redirect_to loyalty_program_coupons_url, notice: 'Loyalty program coupon was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loyalty_program_coupon
      @loyalty_program_coupon = LoyaltyProgramCoupon.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def loyalty_program_coupon_params
      params.require(:loyalty_program_coupon).permit(:loyalty_program_id, :loyalty_program_name, :header, :ad_id, :add_url, :description, :code, :start_date, :expires_at, :created_at, :updated_at, :manually_uploaded)
    end
end
