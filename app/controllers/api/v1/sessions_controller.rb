class Api::V1::SessionsController < Api::V1::ApplicationController

  def create
    if !params[:email].blank? && !params[:password].blank?
      user =  User.where(email: params[:email]).first
      if user
        if user.valid_password?(params[:password])
          render json: get_response(user, params[:device_id])
        else
          render json: {
          success: false,
          message: "Invalid Password"
        }
        end
      else
        render json: {
          success: false,
          message: "Invalid Email"
        }
      end
    else
      render json: {
        success: false,
        message: "Email and Password Can't be blank"
      }
    end
  end

  def destroy
    @token = ApiKey.where(access_token: params[:access_token], expire: true).first
    if @token
        if @token.update_attributes(expire: false)
          render json: {status: true, message: "Log Out successfully"}
        else
          render json: {status: false, message: "Something went wrong"}
        end
      else
        render json: {status: false, message: "Already Logged out/ Invalid token"}
      end
  end

  private

  def get_response(user, device_id)
    {
      success: true, 
      message: "Welcome! Login Successful.",
      token: generate_access_token(user.id, device_id).as_json({
        only: [:access_token]
      })
    }
  end
end
