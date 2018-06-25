class LoyaltyCrawler::Walmart

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://savingscatcher.walmart.com/login"
      s.fill_in('email', with: @loyalty_programs_user.account_id)
      s.find('.js-password').find_css('input').first.set(@loyalty_programs_user.password)
      s.find(".form-actions .btn-block").click
      begin
        s.find('.available_money')
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('.available_money').text.gsub("$", "").to_f, status: "success")
      rescue 
        begin
          s.find('#form-validation-issues') 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#form-validation-issues').text)
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.overlay .middle .message').text)
        end
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
      s.visit "https://savingscatcher.walmart.com/"
      s.click_on"Sign Up"
      s.fill_in('first_name', with: @user.first_name)
      s.fill_in('last_name', with: @user.last_name)
      s.fill_in('username', with: @user.email)
      s.fill_in('confirm_email', with: @user.email)
      s.fill_in('password', with: @user.storepassword)
      s.fill_in('password', with: @user.storepassword)
      s.fill_in('confirm_password', with: @user.storepassword)
      s.fill_in('confirm_password', with: @user.storepassword)
      s.fill_in('zipcode', with: @user.zip_code)
      s.click_on"Create Account"
      begin
        s.find('.available_money')
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('.available_money').text.gsub("$", "").to_f,account_id: @user.email, password: @user.storepassword, status: "success")
      rescue Exception => e
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.signup_box .message .error').text)
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "we'r unable to access your account")
    ensure
      s.driver.quit
      p "Done"
    end
  end

  
end
