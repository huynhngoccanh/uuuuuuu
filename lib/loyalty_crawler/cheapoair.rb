class LoyaltyCrawler::Cheapoair

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.cheapoair.com/"
      begin
        s.find('#signInLink').click
        s.fill_in 'ember590', with: @loyalty_programs_user.account_id
        s.fill_in 'ember598', with: @loyalty_programs_user.password
        s.find('.user__signin-btn').click
        begin
          s.find("#modalDialogContent")
          s.find('.signupClose').click
          s.find("#userProfileData").click
          s.click_on'My Rewards'
          s.find'.rewardsMenuItem'
          @loyalty_programs_user.update_attributes(account_number: 'N/A', points: s.find("#active-points").text.to_f, status: "success")
        rescue 
          begin
            s.find('#ember1003')
            @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember1003').text)
          rescue 
            s.find('#ember994')
            @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember994').text)
          end 
        end
      rescue 
        s.fill_in 'ember998', with: @loyalty_programs_user.account_id
        s.fill_in 'ember1000', with: @loyalty_programs_user.password
        s.find('.user__signin-btn').click
        begin
          s.find("#modalDialogContent")
          s.find('.signupClose').click
          s.find("#userProfileData").click
          s.click_on'My Rewards'
          s.find'.rewardsMenuItem'
          @loyalty_programs_user.update_attributes(account_number: 'N/A', points: s.find("#active-points").text.to_f, status: "success")
        rescue 
          begin
            s.find('#ember1003')
            @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember1003').text)
          rescue 
            s.find('#ember994')
            @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember994').text)
          end 
        end 
      end    
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Something is going wrong please try later")
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
      s.visit "https://www.cheapoair.com/"
      s.execute_script(%{$(".user__form .user__tabs a:contains('Register')").trigger('click')});
      s.fill_in 'ember1006', with: @user.first_name
      s.fill_in 'ember1008', with: @user.last_name
      s.fill_in 'ember1010', with: @user.email
      s.fill_in 'ember1012', with: @user.storepassword
      s.find(".user__register-btn").click
      begin
        s.find('#ember1014')
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember1014').text)
      rescue
        begin
          s.find('#ember1011') 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ember1011').text)
        rescue
          s.find("#modalDialogContent")
          s.find('.signupClose').click
          s.find("#userProfileData").click
          s.click_on'My Rewards'
          @loyalty_programs_user.update_attributes(account_number: 'N/A', points: s.find("#active-points").text.to_f, account_id: @user.email, password: @user.storepassword, status: "success")
        end
      end 
    rescue
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end