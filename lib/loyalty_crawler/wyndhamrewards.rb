class LoyaltyCrawler::Wyndhamrewards


	def initialize(loyalty_programs_user)
		@loyalty_programs_user = loyalty_programs_user
	end

	def get_history
		s = Capybara::Session.new(:poltergeist)
		begin
			s.visit "https://www.wyndhamrewards.com"
			s.fill_in('username',:with=> @loyalty_programs_user.account_id)
			s.fill_in('password',:with=> @loyalty_programs_user.password)
			s.find("#signin").click
			begin
				s.find('.securityQuestionSetup')
				@loyalty_programs_user.update_attributes(account_number: s.find('.right-header').find_css("em").collect(&:all_text).first, points: s.find('.right-header').find_css("em").collect(&:all_text).last, status: "success")			
			rescue Exception => e
				@loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.forgotPassword .formContainer .error').text)
			end			
		rescue Exception => e
	  	@loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
		ensure
			s.driver.quit
			p "Done"
		end
	end

	def check_fields
		@user = @loyalty_programs_user.user
		empty_feilds = []
		{
			first_name: @user.first_name,
			last_name: @user.last_name,
			address: @user.address,
			city: @user.city,
			zip_code: @user.zip_code,
			phone: @user.phone,
			loyalty_password: @user.storepassword
		}.each do |k, v|
			if v.blank?
				empty_feilds << k
			end
		end
		empty_feilds.blank? ? {success: true} : {success: false, required: empty_feilds}
	end

	def signup
		s = Capybara::Session.new(:poltergeist)
		@user = @loyalty_programs_user.user
		@user_name = "#{@user.email.split('@').first.gsub('.', '_')}_ubitru"
		begin
			s.visit "https://www.wyndhamrewards.com/trec/consumer/consumerEnroll.action?variant="
			s.fill_in('firstName', with: @user.first_name)
			s.fill_in('lastName', with: @user.last_name)
			s.fill_in('emailAddress', with: @user.email)
			s.fill_in('addrLine1', with: @user.address)
			s.fill_in('city', with: @user.city)
			s.select("New York", :from =>"states")
			s.fill_in('zipCode', with: @user.zip_code)
			s.fill_in('phoneNumber', with: @user.phone)
			s.fill_in('enrolluserName', with: @user_name)
			s.fill_in('enrollPassword', with: @user.storepassword)
			s.fill_in('enrollPasswordConf', with: @user.storepassword)
			s.click_on "Join Now"
			begin
				s.find('.member_card')
				@loyalty_programs_user.update_attributes(account_number: s.find('.right-header').find_css("em").collect(&:all_text).first, points: s.find('.right-header').find_css("em").collect(&:all_text).last, account_id: @user_name, password: @user.storepassword, status: "success")				
			rescue Exception => e
				@loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.formContainer .errorMessage').text)
			end
		rescue Exception => e
	  	@loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
		ensure
			s.driver.quit
			p "Done"
		end
	end
end
# LoyaltyCrawler::Wyndhamrewards.new.get_deatils("imgopalsharma", "Go@9971907800")
