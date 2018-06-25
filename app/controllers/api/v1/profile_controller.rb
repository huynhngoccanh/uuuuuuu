class Api::V1::ProfileController < Api::V1::ApplicationController
  before_action :find_user
  # Veiw User Information
  def index 
    if @user
      render json: {
       success: true,
       details: @user.as_json({
        only: [:first_name, :last_name, :email, :address, :phone, :storepassword, :score, :city, :zip_code],
        methods: [:total_balance, :balance, :earnings_with_unconfirmed]
        })
      }
    else
      render json: {
       success: false,
       message: "Invalid access token"
      }
    end
  end

  def edit
  end
  # Update User Information
  def update
    if @user
      if @user.update_without_password(user_params)
        render json: {
           success: true,
           message: "Profile successfully Updated"
          }
      else
        render json: {
         success: false,
         message: @user.errors.full_messages.join(", ")
        }
      end
    else
      render json: {
         success: false,
         message: "Invalid access token"
        }
    end
  end

  def user_earning
    if @user
      render json: {
       success: true,
       details: @user.as_json({
        only: [:email],
        methods: [:total_balance, :balance, :earnings_with_unconfirmed]
        })
      }
    else
      render json: {
       success: false,
       message: "Invalid access token"
      }
    end
  end

  private

  def find_user
    @user = ApiKey.where(access_token: params[:access_token], expire:true).first.try(:user)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :zip_code, :phone, :storepassword, :address)   
  end

end