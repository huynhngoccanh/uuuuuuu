class Api::V1::PaymentHistoriesController < Api::V1::ApplicationController

  def create
    @user = ApiKey.where(access_token: params[:access_token], expire: true).first.try(:user)
    @payment_history = PaymentHistory.new(payment_history_params.merge({user_id: @user.id, requested_date: DateTime.now}))
    if @payment_history.save
    	render json: @payment_history
    else
    	render json: {
				success: false,
				message: @payment_history.errors.full_messages.join(", ")
			}
    end
  end

  def create_pay_request
    @user = current_user
    @payment_history = PaymentHistory.new(payment_history_params.merge({user_id: @user.id, requested_date: DateTime.now}))
    if @payment_history.save
      redirect_to earning_info_profile_path, :notice => 'Request successfully sent ' 
    else
      redirect_to earning_info_profile_path, :notice => @payment_history.errors.full_messages.join(", ")
    end
  end

  private

    def payment_history_params
    	params[:payment_history].permit(:paypal_email, :amount)
    end
end