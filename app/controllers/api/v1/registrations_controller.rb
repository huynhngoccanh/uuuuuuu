class Api::V1::RegistrationsController < Api::V1::ApplicationController


  def create
    @user = User.new({:email => params[:email], :password => params[:password], :password_confirmation => params[:password_confirmation],:first_name => params[:first_name],:last_name => params[:last_name], :city => params[:city], :zip_code => params[:zip_code],:phone => params[:phone], :address => params[:address] })
    if @user.save
      render json: {
       success: true,
       message: "successfully signup",
       access_token:  generate_access_token(params[:user_id], @user.id).access_token
      }
    else
      render json: {
       success: false,
       message: @user.errors.full_messages.join(", ")
      }
    end
  end

end
