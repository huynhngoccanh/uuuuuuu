class Api::V1::Admin::MerchantsController < Api::V1::Admin::ApplicationController

	def index
		render json: Merchant.includes(:placements).as_json({
			only: [:id, :name, :slug, :loyalty_enabled, :loyalty_class, :color_palette, :mobile_enabled],
			methods: [:image_url, :icon_url, :advertisers_count, :adverisers, :placements]
		})
	end

	def avant_advertiser
		@advertisers = AvantAdvertiser.paginate(:page => params[:page], :per_page => 100).order("created_at desc").all
		render json: @advertisers.as_json({
			methods: [:merchant, :image_url]
			})
		# render json: Merchant.includes(:placements)
	end

	def cj_advertiser
		
		@advertisers = CjAdvertiser.all
		render json: @advertisers.as_json({
			only: [:id, :name, :slug, :loyalty_enabled, :loyalty_class, :color_palette, :merchant_id],
			methods: [:icon_url, :merchant, :image_url]
		})
	end
	
	def pj_advertiser
		@advertisers = PjAdvertiser.all
		render json: @advertisers.as_json({
			methods: [:merchant,  :image_url]
			})
	end
	def ir_advertiser
		@advertisers = IrAdvertiser.all
		render json: @advertisers.as_json({
			methods: [:merchant, :image_url]
			})
	end
	def linkshare_advertiser
		@advertisers = LinkshareAdvertiser.all
		render json: @advertisers.as_json({
			methods: [:merchant, :image_url]
			})
	end
	
end