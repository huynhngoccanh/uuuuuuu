class Api::V1::StoreController < Api::V1::ApplicationController

	before_action :store_params

	def index
		if store_params[:name]
			@store = Store.where("name like '%#{store_params[:name]}%' OR address like '%#{store_params[:name]}%'")
		end
		render json: @store
	end
	def near_by
		@stores = []
			 # @stores = Store.where("lat LIKE '%#{store_params[:lat].to_f+5}'").all
		@advertisers = Merchant.find(store_params[:id]).advertisers
		@advertisers.each do |advertiser|
			@stores += advertiser.stores.where(lat: ((store_params[:lat].to_f-0.25)..(store_params[:lat].to_f+0.25)), lng: ((store_params[:lng].to_f-0.25)..(store_params[:lng].to_f+0.25))).all
			# where(lat: ((store_params[:lat].to_f-0.25)..(store_params[:lat].to_f+0.25)), lng: ((store_params[:lng].to_f-0.25)..(store_params[:lng].to_f+0.25))).all
			# p advertiser.stores.where(lat: ((store_params[:lat].to_f-0.25)..(store_params[:lat].to_f+0.25)), lng: ((store_params[:lng].to_f-0.25)..(store_params[:lng].to_f+0.25))  ).all
			end

			# @stores = Store.where(lat: ((store_params[:lat].to_f-0.25)..(store_params[:lat].to_f+0.25)), lng: ((store_params[:lng].to_f-0.25)..(store_params[:lng].to_f+0.25))  ).all
			render json: @stores
		
	end

	private 
	 
	    def store_params
	      params.require(:store).permit(:name, :lat, :lng, :id)      
	    end

end