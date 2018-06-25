class Api::V1::PasswordsController < Api::V1::ApplicationController

  def create
    @user = User.find_by_email(params[:email])
    if @user.present?
     @user.send_reset_password_instructions
     render json: {
       success: true,
       message: "Reset password instructions have been sent to #{@user.email}",
       token: @user.reset_password_token
      }
    else
      render json: {
        success: false,
        message: "Invalid Email"
      }
    end
  end
end