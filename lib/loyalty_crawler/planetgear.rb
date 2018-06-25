class LoyaltyCrawler::Planetgear

	def initialize(loyalty_programs_user)
		@loyalty_programs_user = loyalty_programs_user
	end

	def get_history
		s = Capybara::Session.new(:poltergeist)
		begin
			s.visit "https://www.planetgear.com/login.aspx"
			s.fill_in('ctl00$MasterMiddle$txtEmail', :with => @loyalty_programs_user.account_id)
			s.fill_in('ctl00$MasterMiddle$txtPassword', :with => @loyalty_programs_user.password)
			s.find('#ctl00_MasterMiddle_LoginButton').click
      begin
        s.find('#ctl00_navHeader_itemMyAccount')
        s.find('#ctl00_navHeader_itemMyAccount').click
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('#ctl00_navHeader_itemMyCredit').text.split(" ").last.gsub("$", "").to_f, status: "success")
      rescue Exception => e
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_MasterMiddle_lblError').text)
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
    @user_name = "#{@user.email.split('@').first.gsub('.', '_')}_u"
		begin
			s.visit "https://www.planetgear.com/login.aspx"
			s.fill_in('ctl00$MasterMiddle$txtFirstName',:with=>@user.first_name)
			s.fill_in('ctl00$MasterMiddle$txtLastName',:with=>@user.last_name)
			s.fill_in('ctl00$MasterMiddle$txtSignupEmail', :with=>@user.email)
			s.fill_in('ctl00$MasterMiddle$txtSignupPassword', :with=>@user.storepassword)
			s.find('#ctl00_MasterMiddle_SignupButton').click
      begin
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('#ctl00_navHeader_itemMyCredit').text.split(" ").last.gsub("$", "").to_f, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue Exception => e
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_MasterMiddle_lblSignupError').text)
      end		
			
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
	end

end
