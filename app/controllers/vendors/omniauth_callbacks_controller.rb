class Vendors::OmniauthCallbacksController < ApplicationController

  def facebook
    @vendor = Vendor.find_for_facebook_oauth(request.env["omniauth.auth"], current_vendor)

    if @vendor && @vendor.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @vendor, :event => :authentication
    else
      session["devise.vendor_facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_vendor_registration_url
    end
  end
  
  def twitter
    @vendor = Vendor.find_for_twitter_oauth(request.env["omniauth.auth"], current_vendor)

    if @vendor && @vendor.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @vendor, :event => :authentication
    else
      data = request.env["omniauth.auth"]
      data.delete :extra
      session["devise.vendor_twitter_data"] = data
      redirect_to new_vendor_registration_url
    end
  end
  
  def google_oauth2
    @vendor = Vendor.find_for_google_oauth(request.env["omniauth.auth"], current_vendor)

    if @vendor && @vendor.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @vendor, :event => :authentication
    else
      session["devise.vendor_google_data"] = request.env["omniauth.auth"]
      redirect_to new_vendor_registration_url
    end
  end  
  
  def failure
    kind = failed_strategy.name.to_s.humanize
    reason = failure_message
    alert = "Could not authorize you from #{kind} because '#{reason}'."
    redirect_to company_path, :alert => alert
  end

  
  protected

  def failed_strategy
    env["omniauth.error.strategy"]
  end

  def failure_message
    exception = env["omniauth.error"]
    error   = exception.error_reason if exception.respond_to?(:error_reason)
    error ||= exception.error        if exception.respond_to?(:error)
    error ||= env["omniauth.error.type"].to_s
    error.to_s.humanize if error
  end

  
end
