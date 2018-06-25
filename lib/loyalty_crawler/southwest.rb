class LoyaltyCrawler::Southwest

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit('https://www.southwest.com/')
      s.click_on'Log in'
      s.fill_in'username', with: @loyalty_programs_user.account_id
      s.fill_in'password', with: @loyalty_programs_user.password
      s.find('.swa-header--login-submit .swa-header--login-button').click
      # s.debugger
      begin
        s.click_on'My Account'
        @loyalty_programs_user.update_attributes(account_number:s.find('#accountNumber').text, points: s.find('.availablePointsNumber').text ,status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#a11y_error_wrapper').text) 
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#maintenance_wrapper').text)  
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
      p @user.storepassword
      s.visit('https://www.southwest.com')
      s.click_on'Enroll'
      s.fill_in'js-customer-first-name',with:@user.first_name
      s.fill_in'js-customer-last-name',with: @user.last_name
      s.find("#js-customer-birth-month option[value='1']").click
      s.find("#js-customer-birth-day option[value='1']").click
      s.find("#js-customer-birth-year option[value='1990']").click
      s.find("#js-customer-gender option[value='Male']").click
      s.fill_in('js-contact-info-address1',with:'new york')
      s.fill_in('js-contact-info-city',with:'new york')
      s.find("#js-contact-info-state option[value='NY']").click
      s.fill_in('js-contact-info-zip',with:'10001')
      s.fill_in('js-us-area-code',with:'001')
      s.fill_in('js-us-prefix-number',with:'999')
      s.fill_in('js-us-line-number',with:'9999')
      s.fill_in('js-contact-email',with:@user.email)
      sleep 5
      s.fill_in('js-contact-email-confirmation',with:@user.email)
      sleep 5
      s.fill_in('js-username',with:@user_name)
      s.fill_in('account.password',with:@user.storepassword)
      s.fill_in('js-password-confirmation',with:@user.storepassword)
      s.find("#js-security-question-1 option[value='What is the name of your first pet?']").click
      s.fill_in('js-security-answer-1',with:'doggy')
      s.fill_in('js-security-answer-2',with:'black')
      s.find("#js-security-question-2 option[value='What was the color of your first car?']").click
      s.find('#accept-rules-and-regulations').click
      begin
        s.click_on'Create My Account'
        @loyalty_programs_user.update_attributes(account_number: s.find('#accountNumber').text, points: s.find('.availablePointsNumber').text, account_id: @user_name, password: @user.storepassword, status: "success")
      rescue 
       @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#a11y_error_wrapper').text) 
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Oops! Something going wrong.Please try later")
    ensure
      s.driver.quit
      p "Done"
    end
  end
end