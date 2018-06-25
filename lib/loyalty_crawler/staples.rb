class LoyaltyCrawler::Staples

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit('http://www.staples.com/')
      s.execute_script(%{$('.stp--account-name').trigger('click')})
      s.execute_script(%{$('.stp--btn-signIn').trigger('click')})
      s.fill_in('user', with:@loyalty_programs_user.account_id)
      s.fill_in('password', with:@loyalty_programs_user.password)
      s.find('#sign-in-button').click
      # s.click_on'Staples Rewards'
      # s.debugger
      begin
        s.find('.stp--account-name').click
        s.click_on'My Account'
        s.click_on'Staples Rewards'
        @loyalty_programs_user.update_attributes(account_number:s.find('#stp-Rewards-MemberNumber').text, points: s.find('#stp-Rewards-Summary .rewards-price').text.gsub("$", "") ,status: "success")
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception:s.find('.signin-error').text) 
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "You don't have permission to access http://login.staples.com/ on this server.")  
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
      s.visit('http://www.staples.com/')
      s.execute_script(%{$('.stp--account-name').trigger('click')})
      s.click_on'Create an Account'
      s.fill_in'username',with:@user.email
      s.fill_in'password',with:@user.storepassword
      s.execute_script(%{document.getElementsByClassName('stp--icon stp--icon-check-box-empty-2')[1].click()})
      s.fill_in'firstName',with:@user.first_name
      s.fill_in'lastName',with:@user.last_name
      s.fill_in'address1',with:@user.address
      s.fill_in'city',with:@user.city
      s.find("option[value='NY']").click
      s.fill_in'zipCode',with:@user.zip_code
      s.fill_in'phoneNumber',with:@user.phone
      s.find('.signup-btn').click
      begin
        s.find('.stp--account-name').click
        s.click_on'My Account'
        s.click_on'Staples Rewards'
        @loyalty_programs_user.update_attributes(account_number:s.find('#stp-Rewards-MemberNumber').text, points: s.find('#stp-Rewards-Summary .rewards-price').text.gsub("$", ""), account_id: @user.email, password: @user.storepassword, status: "success")
      rescue 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.signup-error').text)
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "BAD SERVER REQUEST! Please try later ")
    ensure
      s.driver.quit
      p "Done"
    end
  end
end