class LoyaltyCrawler::Dicks
	
  def initialize(loyalty_programs_user)
		@loyalty_programs_user = loyalty_programs_user
	end

	def get_history
		s = Capybara::Session.new(:poltergeist)
		begin
			s.visit "https://myscorecardaccount.com/default.aspx"
			s.fill_in('ctl00$LoginScreen$txtNewUsername', :with => @loyalty_programs_user.account_id)
			s.fill_in('ctl00$LoginScreen$txtNewPassword', :with => @loyalty_programs_user.password)
			s.click_on "Sign In"
      begin
        s.find('#ctl00_cph_content_main_lblSCNumber')
        @loyalty_programs_user.update_attributes(account_number: s.find('#ctl00_cph_content_main_lblSCNumber').text, points: s.find(".pnlSummaryContent table:last-child tr:first-child .tdPointSummaryInfo").text.to_f, status: "success")
      rescue Exception => e
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_LoginScreen_lblErrorMessage').text)
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
    @user_name = "#{@user.email.split('@').first.gsub('.', '_')}1"
    begin
      s.visit "https://myscorecardaccount.com/enroll.aspx"
      s.fill_in 'ctl00$cph_content_main$txtFirstName', with: @user.first_name
      s.fill_in 'ctl00$cph_content_main$txtLastName', with: @user.last_name
      s.fill_in 'ctl00$cph_content_main$txtEmailAddress', with: @user.email
      s.fill_in 'ctl00$cph_content_main$txtConfirmEmailAddress', with: @user.email
      s.fill_in 'ctl00$cph_content_main$txtStreet',with:"Abd"
      s.fill_in 'ctl00$cph_content_main$txtApt',with:"678"
      s.fill_in 'ctl00$cph_content_main$txtCity',with:"New York"
      s.select("New York(NY)", :from => "ctl00_cph_content_main_ddlState")
      s.fill_in 'ctl00$cph_content_main$txtPostalCode', with: @user.zip_code     
      s.fill_in('ctl00$cph_content_main$txtPrimaryPhone',:with=>@user.phone)
      s.fill_in('ctl00$cph_content_main$txtPrimaryPhone',:with=>@user.phone)
      s.find('#ctl00_cph_content_main_chkMobileisPrimary').click
      s.fill_in('ctl00$cph_content_main$txtUsername',:with=>@user_name)
      s.fill_in 'ctl00$cph_content_main$txtPassword', with: @user.storepassword
      s.fill_in 'ctl00$cph_content_main$txtConfirmPassword', with: @user.storepassword
      s.click_on "Continue »"
      s.find("#ctl00_cph_content_main_btnChooseAddress")
      s.click_on "Use This Address »"
      begin
        s.find("#ctl00_cph_content_main_btnSave")
        s.find("#ctl00_cph_content_main_btnSave").click
        s.find('#ctl00_SummaryControl1_lblAvailableRewards')      
        @loyalty_programs_user.update_attributes(account_number: s.find('#ctl00_cph_content_main_lblSCNumber').text, points: s.find(".pnlSummaryContent table:last-child tr:first-child .tdPointSummaryInfo").text.to_f, account_id: @user_name, password: @user.storepassword, status: "success")
      rescue Exception => e
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#pnlServerMessage').text)
      end  
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 
end

# LoyaltyCrawler::MyscoreCardAccount.new.get_deatils("gopal221", "Go@9971907800")
