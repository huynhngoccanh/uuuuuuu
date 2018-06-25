class LoyaltyCrawler::Virgin

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.virginamerica.com/"
      s.click_on 'Sign In'
      s.fill_in 'email', with: @loyalty_programs_user.account_id
      s.fill_in 'password', with: @loyalty_programs_user.password
      s.find('.btn-alt-primary').click
      begin
        s.click_on'My Account'
        s.find(".account-info__block--personal")
        @loyalty_programs_user.update_attributes(account_number: s.find(".account-info__block--personal").find_css('dl').last.find_css('dd').first.all_text, points: s.find('.navbar__elevate-nav').find_css('span').last.all_text.split(" ").first, status: "success")
      rescue
        begin
          s.find('.is-error')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.is-error .message').text)
        rescue Exception => e
          @loyalty_programs_user.update_attributes(status: "failed", exception: 'Oops! Enter Valid email or password')   
        end 
      end   
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'Oops! Enter Valid email or password')
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
      s.visit "https://www.virginamerica.com/"
      s.click_on 'Sign Up'
      s.fill_in 'firstName', with: @user.first_name
      s.fill_in 'LastName', with: @user.last_name
      s.fill_in 'email', with: @user.email
      s.fill_in 'confirmEmail', with: @user.email
      s.fill_in 'password', with: @user.storepassword
      s.fill_in 'confirmPassword', with: @user.storepassword
      s.find("#gender option[value='1']").click
      s.find("#select--date-month option[value='1']").click
      s.find("#select--date-year option[value='27']").click
      s.find("#select--date-day option[value='1']").click
      s.find("#country option[value='3']").click
      s.fill_in 'addressOne', with: @user.address
      s.fill_in 'city', with: @user.address
      s.fill_in 'phone', with: @user.phone
      s.find("#country option[value='0']").click
      s.find("#stateSelect option[value='37']").click
      s.fill_in 'zipCode', with: "10001"
      s.find('.extra', text: "Yes, I accept the Elevate").click
      s.click_on "All done. Sign me up!"
      begin
        s.click_on'Store Credit'
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find(".price").text, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.error-msg').text)
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end