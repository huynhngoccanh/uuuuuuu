Warden::Manager.before_logout do |user,auth,opts|
  auth.raw_session[:extension_origin] = nil
end