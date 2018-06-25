MuddleMe::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false
  
  Paperclip.options[:command_path] = "/usr/local/bin/"
  
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  # config.serve_static_assets = true
  #
  
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets

  config.active_record.raise_in_transactional_callbacks = true
  
  # config.action_mailer.asset_host = HOSTNAME_CONFIG['hostname_url']

  # Expands the lines which load the assets
  config.assets.debug = true
  #config.assets.compile= true
  config.action_mailer.default_url_options = { :host => "localhost", :port => '3000' }

  $fb_app_id = SOCIAL_CONFIG['fb_app_id']
  $fb_app_secret = SOCIAL_CONFIG['fb_app_secret']

  $tw_consumer_key = SOCIAL_CONFIG['tw_consumer_key']
  $tw_consumer_secret = SOCIAL_CONFIG['tw_consumer_secret']

  $g_consumer_key = SOCIAL_CONFIG['g_consumer_key']
  $g_consumer_secret = SOCIAL_CONFIG['g_consumer_secret']

  $g_api_key = SOCIAL_CONFIG['g_api_key']

  $bing_basic_auth = SOCIAL_CONFIG['bing_basic_auth']

  $fs_client_id = SOCIAL_CONFIG['fs_client_id']
  $fs_client_secret = SOCIAL_CONFIG['fs_client_secret']

  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
    paypal_options = {
      :login => "4gambi_1337953814_biz_api1.gmail.com",
      :password => "1337953855",
      :signature => "AiPC9BjkCyDFQXbSkoZcgqH3hpacA.YiSEypTMI7xcZezZIlEDF3TDcW"
    }
    authorize_options = {
      :login=>'92QkxMqZ5F7S',
      :password=>'98yEe334CBX2BGwJ'
    }
    ::PAYPAL_STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
    ::PAYPAL_EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
    ::PAYPAL_ADAPTIVE_PAYMENT_GATEWAY = PayPal::SDK::AdaptivePayments::API.new
    ::PAYPAL_MERCHANT_PAYMENT_GATEWAY = PayPal::SDK::Merchant::API.new
    ::CREDIT_CARD_GATEWAY = ActiveMerchant::Billing::AuthorizeNetGateway.new(authorize_options)
  end

#  config.dev_tweaks.autoload_rules do
#    keep :all
#
 #   skip '/favicon.ico'
  #  skip :assets
   # keep :forced
#  end

end
