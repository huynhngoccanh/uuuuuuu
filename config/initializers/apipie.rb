Apipie.configure do |config|
  config.app_name                = "Ubitru"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.translate = false
  config.copyright = "&copy; 2018 MIC Labs"

  config.validate = true
  config.validate_presence = true
  config.validate_value = true
  config.validate_key = true

  config.authenticate = Proc.new do
    # authenticate_or_request_with_http_basic do |username, password|+   #    username == "mic" && password == "mic@123"
    # end
  end
end