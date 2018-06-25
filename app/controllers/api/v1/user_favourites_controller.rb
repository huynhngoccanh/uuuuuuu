class Api::V1::UserFavouritesController < Api::V1::ApplicationController

	def create
		@user_favourite = UserFavourite.new(user_favourite_params.merge(user_id: current_user.id))
		if @user_favourite.save
			render json: @user_favourite
		else
			render json: {
				success: false,
				message: @user_favourite.errors.full_messages.join(", ")
			}
		end
	end

	def destroy
		@user_favourite = UserFavourite.where(user_favourite_params).first
		if @user_favourite.destroy
			render json: {
				success: true
			}
		else
			render json: {
				success: false,
				message: @user_favourite.errors.full_messages.join(", ")
			}
		end
	end


	private

	  def user_favourite_params
	  	params.require(:user_favourite).permit(:resource_id, :resource_type, :user_id)
	  end
  
end