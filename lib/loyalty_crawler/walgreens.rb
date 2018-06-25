class LoyaltyCrawler::Walgreens

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.walgreens.com/login.jsp"
      s.fill_in 'signin-username', with: @loyalty_programs_user.account_id
      s.fill_in 'signin-password', with: @loyalty_programs_user.password
      s.click_button 'Sign In'
      begin
        s.find('#regsuccessoverlay')
        @loyalty_programs_user.update_attributes(account_number: s.find("#wag-balancerewards-brMemberNumber").text.split(" ").last, points: s.find("#wag-balancerewards-availablePoints").text, status: "success")
      rescue 
        s.find('#loginError')
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#loginError').text) 
      end     
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "You're seeing this page because there's a little too much traffic at the corner of happy and healthy")
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
      s.visit "https://www.walgreens.com/register/regpersonalinfo.jsp"
      s.fill_in 'wag-regform-firstname', with: @user.first_name
      s.fill_in 'wag-regform-lasttname', with: @user.last_name
      s.fill_in 'wag-regform-email', with: @user.email
      s.fill_in 'wag-regform-password', with: @user.storepassword
      s.execute_script(%{$("#wag-joinbr-newmember").trigger('click')});
      s.execute_script(%{$("#wag-joinbr-newmember").trigger('click')});
      s.execute_script(%{$("#read_and_agree_walgreens_terms_of_use").trigger('click')});
      s.fill_in('wag-joinbr-phone', :with=>@user.phone)
      s.fill_in('wag-joinbr-zipcodemem', :with=>@user.zip_code)
      s.select('January', :from=>'wag-joinbr-dobmem-month')
      s.select('1', :from=>'wag-joinbr-dobmem-date')
      s.select('1990', :from=>'wag-joinbr-dobmem-year')
      s.click_on"Submit"
      begin
        s.find('.modal-content .wag-close').click 
        s.find('#regsuccessoverlay')
        @loyalty_programs_user.update_attributes(account_number: s.find("#wag-balancerewards-brMemberNumber").text.split(" ").last, points: s.find("#wag-balancerewards-availablePoints").text, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        begin
          s.find('#wag-acinfomin-email-err-exist')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#wag-acinfomin-email-err-exist').text)
        rescue
          s.find('#wag-regform-password-check') 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#wag-regform-password-check').text)
        end
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "You're seeing this page because there's a little too much traffic at the corner of happy and healthy")
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end