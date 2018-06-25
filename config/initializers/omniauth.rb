Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, $fb_app_id, $fb_app_secret, {:path_prefix => "/auth"} 
  provider :twitter, $tw_consumer_key, $tw_consumer_secret, {:path_prefix => "/auth"}
  provider :google_oauth2, $g_consumer_key, $g_consumer_secret, {:path_prefix => "/auth"}

  provider :facebook, $fb_app_id, $fb_app_secret, {:path_prefix => "/api/auth"} 
  provider :twitter, $tw_consumer_key, $tw_consumer_secret, {:path_prefix => "/api/auth"}
  provider :google_oauth2, $g_consumer_key, $g_consumer_secret, {:path_prefix => "/api/auth"}
end
