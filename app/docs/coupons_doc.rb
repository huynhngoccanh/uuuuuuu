module CouponsDoc
  extend Apipie::DSL::Concern

  ###################################################################
  api :GET, '/coupons/send_coupon_by_email', 'send coupon by email'

  # PARAMS
  # PARAM <name>, <type>, description, required: true/false

  param :coupon, String, :desc => "Coupon", :required => true
  param :email, String, :desc => "email", :required => true
  # ERROR CODES with description
  error 401, "Bad Credentials"
  error 500, "Server crashed"
  error 404, "Missing"
  error 422, "Errors. Response {errors: 'string of error'}"

  # FULL DESCRIPTION: How it work, ...
  description <<-EOS
    == Header
      
    == Long description
      send coupon by email
    == How it work
      This API will send coupon by email
  EOS

	# Data example of return
  example <<-EOS
  {
    "success": "ok"
  }
	EOS
  def send_coupon_by_email;end

  ###################################################################
  api :GET, '/coupons/send_coupon_by_sms', 'send coupon by sms'

  # PARAMS
  # PARAM <name>, <type>, description, required: true/false

  param :user_phone_number, String, :desc => "user phone number", :required => true
  param :code, String, :desc => "code", :required => true
  # ERROR CODES with description
  error 401, "Bad Credentials"
  error 500, "Server crashed"
  error 404, "Missing"
  error 422, "Errors. Response {errors: 'string of error'}"

  # FULL DESCRIPTION: How it work, ...
  description <<-EOS
    == Header
      
    == Long description
      send coupon by sms
    == How it work
      This API will send coupon by sms
  EOS

  # Data example of return
  example <<-EOS
  {
    "success": "ok"
  }
  EOS
  def send_coupon_by_sms;end

  
end