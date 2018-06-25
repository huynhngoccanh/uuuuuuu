class Api::V1::Admin::PlacementsController < Api::V1::Admin::ApplicationController

	before_action :set_placement, only: [:update, :destroy]

	def update
		if @placement.update_attributes(placement_params)
			render json: @placement
		else
			render json: {
				success: false,
				message: @placement.errors.full_messages.join(", ")
			}
		end
	end

	def create
		placement = Placement.new(placement_params)
		if placement.save
			render json: placement
		else
			render json: {
				success: false,
				message: placement.errors.full_messages.join(", ")
			}
		end
	end

	def destroy
		render json: {
			success: @placement.destroy
		}
	end

	private

	  def set_placement
	  	@placement = Placement.where(id: params[:id]).first
	  end

	  def placement_params
	  	params.require(:placement).permit(:id, :merchant_id, :location, :description, :code, :expiry, :image, :header)
	  end

end