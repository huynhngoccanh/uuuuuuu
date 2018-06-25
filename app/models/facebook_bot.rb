class FacebookBot
	include HTTParty
	

		def initialize(id,message)
			@access_token = API_CONFIG['fb_access_token']
			@id = id
			@message = message.downcase
			p @message
		end
 
		def send
			options = {}	
			if ["when","due","for","upgrade"].all?{|w| @message.include? w}
				HTTParty.post("https://graph.facebook.com/v2.6/me/messages?access_token=#{@access_token}&recipient[id]=#{@id}&message[attachment][type]=template&message[attachment][payload][template_type]=button&message[attachment][payload][text]=You+are+eligible+for+an+upgrade+today.+Would+you+like+to+shop+for+a+new+device?&message[attachment][payload][buttons][1][type]=web_url&message[attachment][payload][buttons][1][url]=https://staging.ubitru.com&message[attachment][payload][buttons][1][title]=Shop+Now")
				# options.merge!(access_token: @access_token).merge!(recipient:{id: @id}).merge!(message: {attachment: {type: "template", payload: {template_type: "button", text:"You are eligible for an upgrade today. Would you like to shop for a new device?", buttons:[{type:"web_url",url:"https://staging.ubitru.com",title:"Show Website"}]}}})
			else
				message_text = text||@text
				options.merge!(access_token: @access_token).merge!(recipient:{id: @id}).merge!(message: {text: message_text})
				message_request(options)
			end
		end
		


		def text
			if ["hi","hey","hello"].any?{|w| @message==w}
				text = "Hi,#{user}! What a beautiful day.You’ve finally decided to use my services today. So what is the occasion?”"	
			elsif !@message.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i).first.blank?
				query = @message.scan(/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i).first
				begin
					if !User.find_by_email(query).nil?
						User.find_by_email(query).update_attributes(user_bot_id: @id)
						text = "#{query} has been updated."
					else
						f_name = user
						rand_password=(0...8).map { (65 + rand(26)).chr }.join
						@new_user = User.new(email: query,first_name: f_name ,password: rand_password,user_bot_id: @id)
						if @new_user.save
							text ="Now #{query} registered. How can I help you."
						end
					end
				rescue
					text = "Can you please tell me your email id again"
				end
			else
				if get_user.nil?
					text = "Can you please tell me your email id"
				elsif ["are","you","real"].all?{|w| @message.include? w}
					text = "I am the real deal. As good as they come. Are you real?"
				elsif ["what","name","your"].all?{|w| @message.include? w}	
					text = "My name is Caryn and I am your assistant. What is your name?"
				elsif ["how","much","data","have","i"].all?{|w| @message.include? w}
						text = "You have plenty of data remaining for the month: 6.6 GB plus another 4.3 GB carry from last month."
				elsif ["how","old","you"].all?{|w| @message.include? w}
					text ="Age has no meaning because I am Virtual. I was created in Nov 2016 but I am probably still smarter than you.:)"
				elsif ["where","you","live"].all?{|w| @message.include? w}
					text = "I am not sure I am alive but I spend a lot of time in the phone."
				elsif ["how","can","you","help"].all?{|w| @message.include? w}
					text = "I cannot do too much now but I hope one day I will be your BFF or at least a close personal assistant."
				elsif ["which","language","speak"].all?{|w| @message.include? w}
					text = "I speak many languages."
				elsif ["how","are","you"].all?{|w| @message.include? w}
					text = "Excellent!"
				elsif ["what","time","it"].all?{|w| @message.include? w}
					text = "The time is #{Time.now.strftime("%H:%M-%P")} and maybe time for you to get a watch!"	
				elsif ["what","are","hobbies"].all?{|w| @message.include? w}
					text = "I would rather talk about you."
				elsif ["what","you","look","like"].all?{|w| @message.include? w}
					text = "In the cloud, no one cares what you look like."
				elsif ["when","bill","due"].all?{|w| @message.include? w}
					text = "You bill is due on the 19 th of January. Current payment is $236.31"	
				elsif  ["find","tell","what"].any?{|w| @message.include? w} && ["loyalty","number","for"].all?{|w| @message.include? w}
					query = @message.split("for").last.strip.capitalize
					begin
						merchant =  Merchant.where("name Like ?", "%#{query}%").first 
						merchant_id =merchant.try(:id)
						merchant_name = merchant.try(:name)
						 	account_number = get_user.loyalty_programs_users.where(loyalty_program_id: merchant_id).first.try(:account_number)
							if account_number.nil?
							text = "can you please enter the exact name of loyalty program"
							else
							text = "your account number for #{merchant_name} is : #{account_number}"
							end
					rescue Exception => e
						text = "can you please enter the exact name of loyalty program"
					end

				elsif /find|search/.match(@message)
					if /coupon|coupons|deals|deal/.match(@message)
						 get_coupons
					else	
						if get_user.current_loc.blank? && get_user.zip_code.blank?
							text = "Please update your Ubitru profile or send me your current location."
						else
							query = @message.split.last.strip
							get_number(query)
						end
					end	
				elsif @message == "location"
					 	text = "I have updated your current location successfully. :)"
				elsif ["there","any","near"].all?{|w| @message.include? w} && ["coupons","deals","deals/coupons","coupons/deals"].any?{|w| @message.include? w}
						
						text = get_deals
				elsif ["when","due","for","upgrade"].all?{|w| @message.include? w}
					text = "hi"	
				elsif ["remember","my",":"].all? {|w| @message.include? w}
					begin
							query = @message.split("my").last.strip.gsub(" ","")
							key = query.split(":").first
							value = query.split(":").last
							if !(storedata=get_user.storebotdatum.where(datakey: key)).blank?
								p storedata
								 storedata.last.update_attributes(value: value)
								text= "Remembered!"
							else
								store = Storebotdatum.new(user_id: get_user.try(:id),datakey: key,value:value)
								if store.save
									text= "Remembered!"
								else
									text = "Something went wrong"
								end
							end
					rescue 
						text = "Please try again."
					end
				elsif ["tell","my"].all? {|w| @message.include? w} || ["what","my"].all? { |w| @message.include? w}
					begin	
						query = @message.split("my").last.strip.gsub(" ","")				
							data = get_user.storebotdatum.where(datakey: "#{query}")
						# data = get_user.storebotdatum.where('datakey Like ?',"%#{query}%")
						text =data.blank? ? "Couldn't find data for your request. " : "Hey #{get_user.first_name} ! your #{data.first.datakey} : #{data.first.value}."			
					rescue
						text ="Something went wrong"
					end
				elsif ["any","for"].all?{|w| @message.include? w} && ["find","there"].any?{|w| @message.include?w} && ["coupons","deals","deals/coupons","coupons/deals"].any?{|w| @message.include? w}
					query = @message.split("for").last.strip
						begin
						merchant = Merchant.where('name Like ?',"%#{query}%").first
						coupons = merchant.coupons.where("expires_at > ?", Date.today).order("expires_at asc")[0..1]
						p coupons
						if coupons.blank?
							text = "Sorry! No coupons/deals are available"
						else
								text = ""
								i=1
								coupons.each do |w|
									text += (["#{i}) #{JSON.parse(w.try(:header)) rescue w.try(:header)}", (eval(w.try(:code)) rescue w.try(:code))].compact.join(" - "))
									text += "\n"
									i +=1
								end	
								p text
						end
						rescue Exception
							text = "Something went wrong"
						end	
				else	 
					@admin_query=Facebookquery.new(facebook_uid: @id, query: @message)
					if @admin_query.save				
						text ="I have no idea what you are talking about. Are you being silly?"
					end
				end
			end
		end
			
		def get_coupons
			query = @message.split("for").last.strip
						begin
						merchant = Merchant.where('name Like ?',"%#{query}%").first
						coupons = merchant.coupons.where("expires_at > ?", Date.today).order("expires_at asc")[0..1]
						p coupons
						if coupons.blank?
							text = "Sorry! No coupons/deals are available"
						else
								text = ""
								i=1
								coupons.each do |w|
									text += (["#{i}) #{JSON.parse(w.try(:header)) rescue w.try(:header)}", (eval(w.try(:code)) rescue w.try(:code))].compact.join(" - "))
									text += "\n"
									i +=1
								end	
								p text
						end
						rescue Exception
							text = "Something went wrong"
						end	
		end
		def message_request(opts={})
			HTTParty.post("https://graph.facebook.com//v2.6/me/messages/",{body: opts})
		end


		def button_message(coupons)
			coupons = coupons

			p '-------------------------------'
			b="message[attachment][payload][buttons][1][type]=web_url&message[attachment][payload][buttons][1][url]=https://ubitru.com&message[attachment][payload][buttons][1][title]=Shop+Now"
			a=b +"&message[attachment][payload][buttons][2][type]=web_url&message[attachment][payload][buttons][2][url]=https://staging.ubitru.com&message[attachment][payload][buttons][2][title]=Shop+Now"

			HTTParty.post("https://graph.facebook.com/v2.6/me/messages?access_token=#{@access_token}
			 	&recipient[id]=#{@id}&message[attachment][type]=template&message[attachment][payload][template_type]=button&message[attachment][payload][text]
				=You+are+eligible+for+an+upgrade+today.+Would+you+like+to+shop+for+a+new+device?&#{a}")
			# opt={}
			# opt.merge!(access_token: @access_token).merge!(recipient:{id: @id}).merge!(message: {attachment: {type: "template", payload: {template_type: "button", text:"You are eligible for an upgrade today. Would you like to shop for a new device?", :buttons["1"]=>{type:"web_url",url:"https://staging.ubitru.com",title:"Show Website"}}}})
				# opt.merge!(access_token: @access_token).merge!(recipient:{id: @id}).merge!(message: {text: "hello"})
	

				# p opt
				# p HTTParty.post("https://graph.facebook.com/v2.6/me/messages?access_token=#{@access_token}&recipient[id]=#{@id}&message[attachment][type]=template&message[attachment][payload][template_type]=button&message[attachment][payload][text]=You+are+eligible+for+an+upgrade+today.+Would+you+like+to+shop+for+a+new+device?&message[attachment][payload][buttons][1]",{body: {type:"web_url",url:"https://staging.ubitru.com",title:"Show Website"}})
				
		end

		def get_number(query)
			begin 
				service = query
				if get_user.current_loc.blank?
					zipcode = get_user.zip_code
				else
					zipcode = get_user.current_loc
				end	
					url = "https://api.soleo.com/sponsored?Sort=value&Keyword=#{query}&PostalCode=#{zipcode}&APIKey=eraq8qd69saakuun9pnrpjam"
					result = JSON.parse(open(url).read)["businesses"].first
						if result.blank?
							"Requested service is not available"
						else
							name =result["name"]
							cashback = ActionController::Base.helpers.number_to_currency((result["monetizationCritera"]["value"].to_f/3.0))
							link = result["_links"].last["href"]		
							@service_request = ServiceRequest.create(presented_link: link, user_id: get_user.try(:id))
							resp_presented = Net::HTTP.post_form(URI.parse(@service_request.presented_link), {})
							resp_selected = Net::HTTP.post_form(URI.parse(JSON.parse(resp_presented.body)["data"].first["_links"].first["href"]), {})
							resp_getcompletionnumber = JSON.parse(open(URI.parse(JSON.parse(resp_selected.body)["data"].first["_links"].last["href"])).read)
							@service_request.update_attributes(completetion_number: resp_getcompletionnumber["data"].first["completionPhoneNumber"], completion_callback: resp_getcompletionnumber["data"].first["_links"].last["href"],	keyword: service, cashback: cashback.gsub("$"," ").to_f, zip: zipcode )
							Net::HTTP.post_form(URI.parse(@service_request.completion_callback), {})
							number = @service_request.completetion_number
							text = "#{name} : #{number}. For more exact results Please share your current location."
						end
				rescue
					text = "Service is unavailable at your location."
				end
		end

		def update_current_location(id,attachment)
			begin 
				attachment = attachment
				@id = id
				if get_user
					lat = attachment["lat"]
					lng = attachment["long"]
					result = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?latlng=#{lat},#{lng}&sensor=false")
					zip = result["results"].third["address_components"].first["long_name"]
					p zip
					get_user.update_attributes(current_loc: zip,c_lat: lat,c_long: lng, updated_location:  Time.now.strftime("%c"))
				else
					text = "can you please enter the exact name of loyalty program"
				end
			rescue
				text = "I will update your location later."
			end
		end

		def get_deals
			begin
				merchants = ["Macy","Sears", "Nordstrom","Target","Modells","Foot+Locker","Famous+Footwear","Nordstrom","Walgreens","JCPenney"]
				latlng = get_user.c_lat+","+get_user.c_long
				available_merchant = ""
				i=1
				merchants.each_with_index do |w,index|
					result =HTTParty.get("https://maps.googleapis.com/maps/api/place/textsearch/json?query=#{w}&location=#{latlng}&radius=10000&key=AIzaSyCvR3qpBeIPINM-I0xRFgIF-q6qCEyxysM")
					if result["status"]=="OK"
						merchant_name = w.gsub("+", " " )
						
						merchant = Merchant.where("name LIKE ?","%#{merchant_name}%")
						if !merchant.blank?
						coupon= merchant.first.coupons.where("expires_at > ?", Date.today).order("expires_at asc").first
						coupon_head = coupon.try(:header)
							if !coupon_head.blank?
								available_merchant += "#{i}- #{merchant_name} : #{coupon_head}  \n"
								i +=1
							end
						end
					end
				end
				p available_merchant
			rescue 
				text = "Something went wrong"
			end
		end

		def get_user
			if User.where(user_bot_id: @id).first.try(:first_name)
			 @user = User.where(user_bot_id: @id).first
			end
		end
	
		def user
			option = {}
			option.merge!(fields: "first_name").merge!(access_token: @access_token)
			@user = HTTParty.get("https://graph.facebook.com/v2.6/#{@id}?fields=first_name&access_token=#{@access_token}").to_a.last.last
		end

end
