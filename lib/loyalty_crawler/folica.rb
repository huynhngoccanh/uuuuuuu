class LoyaltyCrawler::Folica

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "http://www.folica.com/my-account/sign-in"
      s.find('#close_button').click
      s.fill_in('existingemail', :with=>@loyalty_programs_user.account_id)
      s.fill_in('existingpassword', :with=>@loyalty_programs_user.password)
      s.find('.sign_in .update_btn').click
      begin
        s.click_on'Rewards'
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: s.find('.points_rewards').find_css("span").collect(&:all_text).first.to_f, status: "success")
      rescue 
        begin
          s.find('.field_error')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.field_error').text)
        rescue 
          s.find('.alert') 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.alert').text)
        end    
      end
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: 'unable to accsess your account')
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
    @user_name = "#{@user.email.split('@').first.gsub('.', '_')}_u"
    begin
      s.visit "http://www.folica.com/my-account/sign-in"
      s.find('#close_button').click
      s.fill_in('newFirstName', :with=>@user.first_name)
      s.fill_in('newLastName', :with=>@user.last_name)
      s.fill_in('newEmail', :with=>@user.email)
      s.fill_in('newPassword', :with=>@user.storepassword)
      s.fill_in('newPasswordConfirm', :with=>@user.storepassword)
      s.find('.create_account .update_btn').click
      begin
        s.click_on'My Account'
        s.click_on'Rewards'
        @loyalty_programs_user.update_attributes(account_number:"N/A", points: s.find('.points_rewards').find_css("span").collect(&:all_text).first.to_f, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find(".create_account").find_css('.alert').last.all_text )
      end
    rescue 
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Something is going wrong please after Sometime")
    ensure
      s.driver.quit
      p "Done"
    end  
  end


end

