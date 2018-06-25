class Api::V1::MessengersController < Api::V1::ApplicationController

	# skip_before_filter :verify_authenticity_token
	# skip_before_filter :authenticate_user!

	def messege
		@options ={}
		@access_token ="EAAQ2dszg6I0BAKf2fXrvIcaBqu95yfyL4ppYOjfWq7s61c6ZBcXyb8tQUuyXsuK02SEq8Nt1bopcceZCrnh2Jxq8mpEZC7BXWBpUwn0JsgV4NVf2WpdjYalWKFocUkZCANtr5S3ODIqw2FzOo6VapLHXxOWsqSVmCXk4G5kMKwZDZD"

		@options.merge!(access_token: @access_token).merge(params)

		HTTParty.post("https://graph.facebook.com//v2.6/me/messages/",{body: @options})
	end
end