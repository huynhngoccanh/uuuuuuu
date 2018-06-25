class Api::V1::LoyaltyProgramsUsersController < Api::V1::ApplicationController
	before_filter :set_user , :only=>['update']
	def create
		@user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
		@loyalty_programs_user = LoyaltyProgramsUser.new(loyalty_programs_user_params.merge({user_id: current_user.try(:id) || @user.try(:id)}))
		(@all_done = (@loyalty_programs_user.loyalty_program.loyalty_class).constantize.new(@loyalty_programs_user).check_fields) if @loyalty_programs_user.is_signup
 
		
		if (!@loyalty_programs_user.is_signup || @all_done[:success] || @loyalty_programs_user.is_hardcoded) && @loyalty_programs_user.save
			render json: {
				success: true,
				details:@loyalty_programs_user.as_json({
					only: [:account_id, :status, :points, :account_number],
					methods: [:loyalty_program]
					})
			}
			else
			render json: {
				success: false,
				message: @all_done[:success] ? @loyalty_programs_user.errors.full_messages.join(", ") : "Please updates #{@all_done[:required].join(', ')}"
			}
		end
	end

	def update
		@loyalty_programs_user = @user.loyalty_programs_users.find(params[:id])
		@loyalty_programs_user.update_attributes(loyalty_programs_user_params.merge({exception: nil}))
		@loyalty_programs_user.update_program
		render json: { success: true }
	end

	def destroy
		@user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
		@loyalty_program_user = @user.loyalty_programs_users.where(id: params[:id]).first
		if @loyalty_program_user.destroy
			render json: {
				success: true,
					message: "Loyalty Programs has been deleted"
				}
		else
			render json: {
				success: false,
					message: "Oops! Something went wrong"
				}
		end
	end

	private

	  def loyalty_programs_user_params
	  	params[:loyalty_programs_user].permit(:account_id, :password, :loyalty_program_id, :is_signup, :is_hardcoded, :account_number,:key)
	  end
  
	  def set_user
	  	@user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user) || current_user
	  end
end