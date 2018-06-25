class LoyaltyCrawler::Nordstrom

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "http://shop.nordstrom.com/"
      s.execute_script(%{$("#closeButton").click()});
      s.click_on 'Sign In'
      p"1"
      s.fill_in 'ctl00_mainContentPlaceHolder_signIn_email', with: @loyalty_programs_user.account_id
      s.fill_in 'ctl00_mainContentPlaceHolder_signIn_password', with: @loyalty_programs_user.password
      s.find('#ctl00_mainContentPlaceHolder_signIn_enterButton').click
      p "2"
      begin
        s.find('.recommendations-upper')
        s.find('#customer-greeting').click
        @loyalty_programs_user.update_attributes(account_number: 'N/A', points: 0, status: "success")
      rescue
        begin
          s.find("#ctl00_mainContentPlaceHolder_signIn_loginError_mainMessageLabel")
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find("#ctl00_mainContentPlaceHolder_signIn_loginError_mainMessageLabel").text)
        rescue Exception => e
          s.find('#ctl00_mainContentPlaceHolder_signIn_validatorEmailAddressValid')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find("#ctl00_mainContentPlaceHolder_signIn_validatorEmailAddressValid").text)
        end
      end   
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'this is under maintenance')
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
      s.visit "http://shop.nordstrom.com/"
      s.click_on 'Sign In'
      s.execute_script(%{$("#closeButton").click()});
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_firstNameTextBox', with: @user.first_name
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_emailAddressTextBox', with: @user.email
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_emailAddressConfirmTextBox', with: @user.email
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_passwordTextBox', with: @user.storepassword
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_passwordConfirmTextBox', with: @user.storepassword
      s.fill_in 'ctl00_mainContentPlaceHolder_accountProfileForm_zipCodeTextBox', with: @user.zip_code
      s.find("option[value='3']").click
      s.find('#ctl00_mainContentPlaceHolder_submitRegistrationImageButton').click
      begin
        s.find('#ctl00_mainContentPlaceHolder_SignInNordUserControl_editSignInEmailDiv')
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: 0, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        s.find('#ctl00_mainContentPlaceHolder_accountProfileForm_accountProfileErrorDisplay_mainMessageLabel') 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_mainContentPlaceHolder_accountProfileForm_accountProfileErrorDisplay_mainMessageLabel').text)
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end