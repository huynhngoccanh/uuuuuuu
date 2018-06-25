class Users::UserServiceProvidersController < ApplicationController
  before_filter :authenticate_user!

  def new
    @service_provider = UserServiceProvider.new
    render :layout => "new_resp_popup"
  end

  def create
    @service_provider = current_user.user_service_providers.new(
      :merchant_name => params[:merchant_name],
      :merchant_address => params[:merchant_address],
      :email => params[:email],
      :phone => params[:phone]
    )
    @service_provider.save
  end
end
