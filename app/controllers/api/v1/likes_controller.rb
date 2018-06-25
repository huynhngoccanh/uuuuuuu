class Api::V1::LikesController < Api::V1::ApplicationController
	before_action :user_like_params , :find_like 
	
	def create
		if !@like.nil?	
			@user_like = @like.update_attributes(dislike: "#{user_like_params[:dislike]}",like: "#{user_like_params[:like]}")
				if !@user_like.nil?
					render json: @user_like
				else
				render json: {
					success: false,
					message: @user_like.errors.full_messages.join(", ")
				}
				end
		else		
			@user_like = Like.new(user_like_params.merge(user_id: current_user.id))
			if @user_like.save
				render json: @user_like
			else
				render json: {
					success: false,
					message: @user_like.errors.full_messages.join(", ")
				}
			end
		end	
	end

	
	def destroy
		@user_like = Like.where(user_like_params).first
		if @user_like.destroy
			render json: {
				success: true
			}
		else
			render json: {
				success: false,
				message: @user_like.errors.full_messages.join(", ")
			}
		end
	end

	private
		def find_like
			@like = Like.find_by(user_id: "#{current_user.id}",resource_id: "#{user_like_params[:resource_id]}",resource_type: "#{user_like_params[:resource_type]}")
		end

	
		def user_like_params
			params.require(:user_like).permit(:resource_id, :resource_type, :user_id, :like, :dislike)
		end
  
end