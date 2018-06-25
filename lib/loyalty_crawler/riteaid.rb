class LoyaltyCrawler::Riteaid

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit('https://www.riteaid.com')
      p "1"
      s.click_on'Log In to Wellness'
      p "2" 
      s.fill_in'UserTextboxBt',with:@loyalty_programs_user.account_id
      p "3"
      s.fill_in'LoginTextboxBt',with:@loyalty_programs_user.password
      s.find('#loginBtn').click
      # s.debugger
      begin
        s.find('#dashboardStatusAndDiscount')
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: s.find('#points').find_css('tr').first.find_css('td').last.all_text ,status: "success")
      rescue
        s.find('#login-layout-table')
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.errorMessage').text)
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Cannot access this websites Our support team update is soon")  
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
      email: @user.email,
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
    @user_name = "#{@user.email.split('@').first.gsub('.', '_')}_ubi"
    begin
      s.visit('https://www.riteaid.com')
      s.click_on'Sign Up'
      s.fill_in'wellnessfirstname', with: 'gopal'
      s.fill_in'wellnesslastname', with: 'sharma'
      s.fill_in'emailAddress', with: 'gopal12121@example.com'
      s.fill_in'newpassword', with: 'Go9971907800'
      s.fill_in'userName', with: 'gopal997190'
      s.find('#plenti-question').find_css('div').last.click
      s.find('#wellnessCardQuestion').find_css('.radiobt').second.click
      s.click_on'Go to Plenti Now'
      s.fill_in'dateOfBirth_month', with: '01'
      s.fill_in'dateOfBirth_day', with: '01'
      s.fill_in'dateOfBirth_year', with: '1990'
      s.fill_in'mobileNumber[PhoneNumberField]', with: '9898767890'
      s.fill_in'street', with: 'noida'
      s.fill_in'city', with: 'noida'
      s.find('.error')
      # s.debugger
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Cannot access this websites")
    ensure
      s.driver.quit
      p "Done"
    end
  end
end
