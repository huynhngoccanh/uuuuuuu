class Api::V1::CouponsController < Api::V1::ApplicationController
	before_filter :set_user

  before_action :authenticate_with_token!, only: [:get_coupons]
  include CouponsDoc
  
	def create
		if @user || current_user
			@coupon = Coupon.new(coupon_params.merge({user_id: current_user.try(:id) || @user.try(:id), manually_uploaded: true}))
			if @coupon.save
				render json: @coupon
			else
				render json: {
					success: false,
					message: @coupon.errors.full_messages.join(", ")
				}
			end
		else
			render json: {
					success: false,
					message: "Invalid token"
				}
		end
	end

  def coupons
    coupons = []
    if params[:taxon]
        coupons = coupons_by_taxon
    elsif params[:merchant_name]
        coupons = coupons_by_merchant_name
    end

    render json: {result: coupons}
  end

  def send_coupon_by_email
    coupon = params[:coupon]
    email  = params[:email]
    
    ContactMailer.send_coupons_notification(coupon, email).deliver
    render json: {
      success: "ok"
    }
  end

  def send_coupon_by_sms
    @client = Twilio::REST::Client.new SOCIAL_CONFIG['sms_acc_sid'], SOCIAL_CONFIG['sms_acc_token']
    @message_body = "Welcome to Ubitru, the code is #{params[:code]}"
    begin
      response = @client.account.sms.messages.create(
        :from => SOCIAL_CONFIG['sms_from_number'],
        #:to =>  '+16105557069',
        :to => params[:user_phone_number],
        :body =>  @message_body
      )
      render json: {
        success: 'ok'
      }
    rescue => e
      render json: { errors: e.message }
    end
  end

	private

	  def set_user
	  	@user = current_user || ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
	  end

	  def coupon_params
	  	params[:coupon].permit(:description, :code, :coupon_type, :temp_website, :expires_at, :print, :url)
	  end

	  # def check_existance
	  # 	@coupon_exist = Coupon.where(coupon_type: '#{params[:coupon_type]}' AND code: "#{params[coupon_type]}")
	  # end

    def authenticate_with_token!
      @user.present? || render_unauthorized
    end

    def render_unauthorized(realm = "Application")
      self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
      render json: { errors: 'Bad credentials' }, status: :unauthorized
    end

    def coupons_by_taxon
      merchant_ids = []
      coupons = []

      taxon_search = Taxon.search do
        fulltext params[:taxon], :fields => :name
      end

      taxons = taxon_search.results

      if taxons.present?
        taxons.each do |t|
          merchant_ids << t.merchants.map(&:id)
        end
        merchant_ids.flatten!
        coupons = Coupon.joins(:merchant)
                        .select("coupons.id, coupons.code, coupons.header, coupons.description, coupons.expires_at, merchants.name AS merchantname")
                        .where("coupons.merchant_id in (?) and coupons.expires_at >= now()", merchant_ids)
      end

      coupons
    end

    def coupons_by_merchant_name
      coupons = []

      merchant_search = Merchant.search do
        fulltext params[:merchant_name], :fields => :name
      end

      merchants =  merchant_search.results

      if merchants.present?
        merchant_ids = merchants.map(&:id)
        coupons = Coupon.joins(:merchant)
                        .select('coupons.id, coupons.code, coupons.header, coupons.description, coupons.expires_at, merchants.name as merchantname')
                        .where("coupons.merchant_id in (?) and coupons.expires_at >= now()", merchant_ids)
      end

      coupons
    end
end
