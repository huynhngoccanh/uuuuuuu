class LoyaltyCrawler::Choice


  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "http://www.choies.com/customer/login"
      s.find(".close-reveal-modal").click
      s.fill_in'sign-in-email',:with=>@loyalty_programs_user.account_id
      s.execute_script(%{$("input[name=password]").val("#{@loyalty_programs_user.password}")});
      s.click_on"Sign In"
      begin
        s.find("#username")
        s.find("#username").click
        s.click_on"My Profile"
        s.click_on"Points History"
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: 0 ,status: "success")
      rescue
        begin
          s.find('.error')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.error').text)
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.remind-error').text)
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
      s.visit "http://www.choies.com/customer/login"
      s.find(".close-reveal-modal").click
      s.execute_script(%{$("input[name=email]").val("#{@user.email}")});
      s.execute_script(%{$("input[name=password]").val("#{@user.storepassword}")});
      s.execute_script(%{$("input[name=password_confirm]").val("#{@user.storepassword}")});
      s.click_on "Sign Up"
      begin
        s.find("#username").click
        s.click_on"My Profile"
        s.click_on"Points History"
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: 0 ,status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.remind-error').text)
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end
