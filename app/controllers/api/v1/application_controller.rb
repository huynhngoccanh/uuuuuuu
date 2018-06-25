class Api::V1::ApplicationController < ActionController::Base

	skip_before_filter :verify_authenticity_token
	skip_before_filter :authenticate_user!

	def default_serializer_options
	  {root: false}
	end


  def generate_access_token(user_id, device_id)
    ApiKey.create({
      access_token: (Digest::SHA1.hexdigest "#{Time.now.to_i}#{1}"),
      user_id: user_id,
      expire: true,
      device_id: device_id
    })
  end
end