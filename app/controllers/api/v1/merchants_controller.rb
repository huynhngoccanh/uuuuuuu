class Api::V1::MerchantsController < Api::V1::ApplicationController

	before_filter :set_merchant 

	def show
		render json: @merchant
	end

  def coupons
    @merchant.coupons.paginate(:page => params[:page], :per_page => 5).order("header asc")
    if params[:q]
      @merchant.coupons.where("header like '%#{params[:q]}%'")
    end
    @coupons = {}
    @coupons = @merchant.coupons.where('expires_at >?', Date.today)
    @coupons += @merchant.coupons.where(expires_at: nil)
    @sorted = @coupons.sort_by{|k| k[:created_at]}.reverse
    render json: @sorted.as_json({
      methods: [:image],
      include:{
        merchant:{
          only: [:name],
          methods: [:redirection_link]
        }
      },
    })
  end

  def mobile_created
    @user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
    
    if merchant_params[:name] == "" 
      render json: {
        success: false,
        message: 'Enter The Store Name.'  
      }
      
    else
      if @user
        @merchant = Merchant.new(merchant_params.merge({user_id: @user.id , mobile_created: true }))
          if @merchant.save
            @merchant.update_merchant_slug
            render json:{
              success: true,
              merchant: @merchant.as_json
            }
           end  
      else
        render json: {
          success: false,
          message: "Invalid Access Token."
        }
      end
    end
  end

  def index
    @merchants = Merchant.where(mobile_enabled: true).paginate(:page => params[:page], :per_page => 30).order("name asc")
    if params[:q]
      @merchants = @merchants.where("name like '%#{params[:q]}%'")
    end
    render json: @merchants
  end

  def merchant_find
    render json: set_merchant.as_json({
      only: [:name]
      })  
  end

	private 

	  def set_merchant
	  	@merchant = Merchant.where(id: params[:id]).last
	  end
   
    def merchant_params
      params[:merchant].permit!
      
    end
end