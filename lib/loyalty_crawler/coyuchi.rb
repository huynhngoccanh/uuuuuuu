class LoyaltyCrawler::Coyuchi

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin 
      s.visit 'https://www.coyuchi.com/customer/account/login'
      s.fill_in 'login[username]', :with => @loyalty_programs_user.account_id
      s.fill_in 'login[password]', :with => @loyalty_programs_user.password
      s.click_on 'Login'
      begin
        s.find('.dashboard')
        s.find('#close-button').click
        s.click_on'Store Credit'
        @loyalty_programs_user.update_attributes(account_number: 'N/A', points: s.find(".account-balance .price").text.gsub("$", "").to_f, status: "success")
      rescue
        begin
          s.find('#advice-validate-email-email')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#advice-validate-email-email').text) 
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.messages .error-msg').text)
        end               
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'Something is going wrong please try after sometime')
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
      s.visit "https://www.coyuchi.com/customer/account/create/"
      s.fill_in 'firstname', with: @user.first_name
      s.fill_in 'lastname', with: @user.last_name
      s.fill_in 'email_address', with: @user.email
      s.fill_in 'password', with: @user.storepassword
      s.fill_in 'confirmation', with: @user.storepassword
      s.find('#close-button').click
      s.click_on "Register"
      begin
        s.find('.dashboard')
        s.click_on'Store Credit'
        @loyalty_programs_user.update_attributes(account_number: 'N/A', points: s.find(".account-balance .price").text, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.messages .error-msg').text)        
      end      
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'Something is going wrong please try after sometime')
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end
