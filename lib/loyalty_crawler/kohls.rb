class LoyaltyCrawler::Kohls


  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.kohls.com"
      s.find('#utility-nav').click
      s.find('.emailField').set(@loyalty_programs_user.account_id)
      s.find('.pwdField').set(@loyalty_programs_user.password)
      s.execute_script(%{$(".kas-loginPage-signin-button-SignIn").click()});
      begin
        s.visit"https://www.kohls.com/myaccount/kohls_rewards.jsp"
        s.find('#kRewardsId')
        @loyalty_programs_user.update_attributes(account_number:s.find('#kRewardsId').text, points: s.find('#balAftShare').text.to_f ,status: "success")
      rescue
        begin
          s.find('#error')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#error').text)
        rescue
          s.find('.kas-loginPage-signin-emailField-validemailError') 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('kas-loginPage-signin-emailField-validemailError').text)
        end
      end     
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'Your session expired due to inactivity.')
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
      s.visit "https://www.kohls.com"
      s.find('#utility-nav').click
      s.click_on'CREATE ACCOUNT'
      s.find('.rd-fnameField').set(@user.first_name)
      s.find('.rd-lnameField').set(@user.last_name)
      s.find('.rd-emailField').set(@user.email)
      s.find('.rd-pwdField').set(@user.storepassword)
      s.click_on'CREATE ACCOUNT'
      begin
        s.visit"https://www.kohls.com/myaccount/kohls_rewards.jsp"
        s.find('#kRewardsId')
        @loyalty_programs_user.update_attributes(account_number:s.find('#kRewardsId').text, points: s.find('#balAftShare').text.to_f, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        begin
          s.find('#error')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#error').text)
        rescue Exception => e
          @loyalty_programs_user.update_attributes(status: "failed", exception: "Cannot access this websites")
        end
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "At Least 8 Characters Long ,Numbers and Letters (ABC123),Upper and Lower case")
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end
