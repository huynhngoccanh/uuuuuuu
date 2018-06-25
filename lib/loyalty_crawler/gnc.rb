class LoyaltyCrawler::Gnc

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit('http://www.gnc.com')
      s.click_on'Log In'
      s.fill_in'emailId',with:@loyalty_programs_user.account_id
      s.fill_in'passwd',with:@loyalty_programs_user.password
      s.find('.accountLoginAndRegistrationForms').find_css('td').first.find_css('.button-inverted').last.click
      # s.debugger
      begin
        s.find('#myAccount')
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: 0 ,status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#processlogin').find_css('table').second.all_text)
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Cannot access this websites")  
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
      s.visit('http://www.gnc.com')
      s.click_on'Register'
      s.fill_in'emailAddExmpl', with: @user.email
      s.fill_in'passwrd', with: @user.storepassword
      s.fill_in'confPasswrd', with: @user.storepassword
      s.click_on'Create Account'
      s.debugger
      begin
        s.find('#myAccount')
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: 0 ,status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#processlogin').find_css('table').second.all_text)
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Cannot access this websites")
    ensure
      s.driver.quit
      p "Done"
    end
  end
end
