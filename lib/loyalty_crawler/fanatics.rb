class LoyaltyCrawler::Fanatics

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.fanatics.com/rewards/signuplogin"
      s.execute_script(%{$("#lightboxCloseImg").click()});
      s.fill_in'Login_UserName', with: @loyalty_programs_user.account_id
      s.fill_in'Login_Password', with: @loyalty_programs_user.password 
      s.click_on'Sign In'
      begin
        s.find('.RegisteredMemberSignedUp .expand').click
        # s.execute_script(%{$(".account-login a:contains('My Account')").click()})
        s.visit"https://www.fanatics.com/account/home"
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('.account .name').text.split(" ").last.gsub("$", "").to_f, status: "success")
      rescue
        s.find('#ui-rewards-message') 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ui-rewards-message').text)
      end   
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Opps Something is going wrong,Our support team update it soon")
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
      s.visit "https://www.fanatics.com/rewards/signuplogin"
      s.execute_script(%{$("#lightboxCloseImg").click()});
      s.fill_in 'rewards_club__signup__firstname', with: @user.first_name
      s.fill_in 'rewards_club__signup__lastname', with: @user.last_name
      s.fill_in 'rewards_club__signup__userName', with: @user.email
      s.fill_in 'rewards_club__signup_password', with: @user.storepassword
      s.click_on "Join Now"
      begin
        s.find('.SignUpSuccess .expand').click
        # s.execute_script(%{$(".RegisteredMemberSignedUp .expand").trigger('click')}); 
        s.find('.account-name .user-name-section').click
        s.click_on'My Account'
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: s.find('.totalCreditAmount').text.split(" ").first.gsub("$", "").to_f, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        begin
          s.find('.RegisteredMemberSignedUp .expand').click 
          s.find('.account-name .user-name-section').click
          s.click_on'My Account'
          @loyalty_programs_user.update_attributes(account_number:"N/A", points: s.find('.totalCreditAmount').text.split(" ").first.gsub("$", "").to_f, account_id: @user.email, password: @user.storepassword, status: "success")
        rescue 
          s.find('#ui-rewards-message')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ui-rewards-message').text)
        end
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "we'r sorry to create your account. please try after sometime")
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end