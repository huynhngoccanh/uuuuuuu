class Users::Devise::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    omniauth = request.env["omniauth.auth"]
    p '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
    p request.env["omniauth.auth"]
    @user = User.find_for_facebook_oauth(omniauth, current_user)
   
    if @user && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    elsif current_user
      current_user.dont_require_password = true
      current_user.facebook_uid = omniauth['uid']
      current_user.facebook_token = omniauth['credentials']['token']
      if current_user.save
        flash[:notice] = "Authentication successful."
        redirect_to new_users_settings_path
      else
        flash[:alert] = "Authentication failed: #{current_user.errors.full_messages.to_s.humanize}"
        redirect_to new_users_settings_path
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]

      redirect_to new_user_registration_url(facebook: true)
    end
  end

  def twitter
    omniauth = request.env["omniauth.auth"]
    @user = User.find_for_twitter_oauth(omniauth, current_user)

    if @user && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    elsif current_user
      current_user.dont_require_password = true
      current_user.twitter_uid = omniauth['uid']
      current_user.twitter_token = omniauth['credentials']['token']
      current_user.twitter_secret = omniauth['credentials']['secret']
      if current_user.save
        flash[:notice] = "Authentication successful."
        redirect_to new_users_settings_path
      else
        flash[:alert] = "Authentication failed: #{current_user.errors.full_messages.to_s.humanize}"
        redirect_to new_users_settings_path
      end
    else
      data = request.env["omniauth.auth"]
      data.delete :extra
      session["devise.twitter_data"] = data
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    omniauth = request.env["omniauth.auth"]
    @user = User.find_for_google_oauth(omniauth, current_user)

    if @user && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    elsif current_user
      current_user.dont_require_password = true
      current_user.google_uid = omniauth['uid']
      current_user.google_token = omniauth['credentials']['token']
      if current_user.save
        flash[:notice] = "Authentication successful."
        redirect_to new_users_settings_path
      else
        flash[:alert] = "Authentication failed: #{current_user.errors.full_messages.to_s.humanize}"
        redirect_to new_users_settings_path
      end
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def failure
    set_flash_message :alert, :failure, :kind => failed_strategy.name.to_s.humanize, :reason => failure_message
    redirect_to root_path
  end

end