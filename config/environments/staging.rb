MuddleMe::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  # config.middleware.insert_before ActionDispatch::Static, Rack::SSL, :exclude => proc { |env| env['HTTPS'] != 'on' }
  config.cache_classes = true

  config.eager_load = true
  
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  Rails.application.config.middleware.use ExceptionNotification::Rack,
  email: {
    :email_prefix => "[Error 500] ",
    :sender_address => %{"Ubitru Notifier" <exception@ubitru.com>},
    :exception_recipients => %w{kevin.m.brothers@gmail.com nasir031@gmail.com}
  }

  # Disable Rails's static asset server (Apache or nginx will already do this)
  # config.serve_static_assets = true
  config.serve_static_files = true

  # Compress JavaScripts and CSS
  config.assets.compress = true
  require 'www_ditcher'
  config.middleware.use "WwwDitcher"
  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( vendors.css file_upload.css video-js.css video-js-custom.css print.css print_preview.css search.css)
  config.assets.precompile << '*.js'

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true
  # config.action_mailer.asset_host = HOSTNAME_CONFIG['hostname_url']
  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'http://staging.ubitru.com' }
  config.action_mailer.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => false,
    :openssl_verify_mode => 'none'
  }

  $fb_app_id = SOCIAL_CONFIG['fb_app_id']
  $fb_app_secret = SOCIAL_CONFIG['fb_app_secret']

  $tw_consumer_key = SOCIAL_CONFIG['tw_consumer_key']
  $tw_consumer_secret = SOCIAL_CONFIG['tw_consumer_secret']

  $g_consumer_key = SOCIAL_CONFIG['g_consumer_key']
  $g_consumer_secret = SOCIAL_CONFIG['g_consumer_secret']

  $g_api_key = SOCIAL_CONFIG['g_api_key']

  $fs_client_id = SOCIAL_CONFIG['fs_client_id']
  $fs_client_secret = SOCIAL_CONFIG['fs_client_secret']

  $bing_basic_auth = SOCIAL_CONFIG['bing_basic_auth']

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test unless SOCIAL_CONFIG['merchant_production_mode']
    paypal_options = {
      :login => SOCIAL_CONFIG['paypal_login'],
      :password => SOCIAL_CONFIG['paypal_password'],
      :signature => SOCIAL_CONFIG['paypal_signature']
    }
    authorize_options = {
      :login    =>  SOCIAL_CONFIG['authorize_login'],
      :password =>  SOCIAL_CONFIG['authorize_password'],
    }
    ::PAYPAL_STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::PAYPAL_EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
    ::PAYPAL_ADAPTIVE_PAYMENT_GATEWAY = PayPal::SDK::AdaptivePayments::API.new
    ::PAYPAL_MERCHANT_PAYMENT_GATEWAY = PayPal::SDK::Merchant::API.new
    ::CREDIT_CARD_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(authorize_options)
  end
end