class FacebookChat

	include HTTParty

	base_uri "https://graph.facebook.com/"

  #should only need the current tenant to get the required info. this is in the session?
	def initialize()
	  @access_token = "EAAQ2dszg6I0BAKf2fXrvIcaBqu95yfyL4ppYOjfWq7s61c6ZBcXyb8tQUuyXsuK02SEq8Nt1bopcceZCrnh2Jxq8mpEZC7BXWBpUwn0JsgV4NVf2WpdjYalWKFocUkZCANtr5S3ODIqw2FzOo6VapLHXxOWsqSVmCXk4G5kMKwZDZD"
	  #todo change to tenant_integrations.ordoro_name, tenant_integrations.ordoro_pass
		# @auth = { username: username, password: password }
	  @headers =  {'Content-Type' => 'application/json' }
	end

	def send(opts={})
		options = {}
		options.merge!(@headers).merge!(access_token: @access_token).merge!(opts)
		self.class.post("/v2.6/me/messages/", {body: options})
	end

	# def create_order(body, opts = {})
	# 	options = {}
	# 	options.merge!(query: opts).merge!({ :basic_auth => @auth }).merge!({ :headers => @headers }).merge!({ body: body })
	# 	self.class.post('/order/', options)
	# end

	# def update_order(order_id, body, opts = {})
	# 	options = {}
	# 	options.merge!(query: opts).merge!({ :basic_auth => @auth }).merge!({ :headers => @headers }).merge!({ body: body })
	# 	self.class.put("/order/#{order_id}/", options)
	# end

	# def products(opts = {})
	# 	options = {}
	# 	options.merge!(query: opts).merge!({ :basic_auth => @auth }).merge!({ :headers => @headers })
	# 	self.class.get('/product/', options)
	# end

	# def products_count(opts = {})
	# 	options = {}
	# 	options.merge!(query: opts).merge!({ :basic_auth => @auth }).merge!({ :headers => @headers })
	# 	self.class.get('/product/counts/', options)
	# end

end

# 2.2.4 :576 >   response = HTTParty.post("https://graph.facebook.com/v2.6/me/messages?access_token=EAAQ2dszg6I0BACzEtt0KqdN8ZAZAk4pJVJRa8b8D6lEDzzhxaZBJbOusOfTHd1Fn57OPe1A1M4kUZBC5152u4CxTBH9HcQtvDy9KdrZA1iIjJS9kGy6K7qPZBMq08a7Gp9nPdelKsffag4qz4DWY2xpczFvCT1MoR5RTlrv7dDRAZDZD
# &recipient[id]=1282671105138039&message[text]=hello gopalhsdkjfsdkfjs")
# {recipient: {id: "1282671105138039"}, message: {text: "hello work"}}