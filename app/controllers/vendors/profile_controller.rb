class Vendors::ProfileController < ApplicationController
  before_filter :authenticate_vendor!


  def show

  end

  def update
    @vendor = current_vendor
    @vendor.dont_require_password = true if params[:password].nil?
    if @vendor.update_attributes(params[:vendor])
      sign_in @vendor, :bypass => true
      redirect_to profile_url, :notice => 'Profile was successfully updated.'
    else
      render :action => "show"
    end

  end

end
