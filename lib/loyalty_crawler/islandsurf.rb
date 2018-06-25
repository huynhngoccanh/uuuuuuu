class LoyaltyCrawler::Islandsurf

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "https://www.islandsurf.com/account/login"
      s.execute_script(%{$(".fancybox-close").click()});
      s.fill_in'customer_email', with:@loyalty_programs_user.account_id
      s.fill_in'customer_password', with:@loyalty_programs_user.password
      s.click_on'Sign In'
      begin
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        p "----------------"
        s.find('.email .reward-points')
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('.email .reward-points').text.to_f, status: "success")
      rescue 
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.errors').text)
      end   
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "we'r unable to access your account,check your details")
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
      s.visit "https://www.islandsurf.com/account/register"
      s.execute_script(%{$(".fancybox-close").click()});
      s.fill_in 'first_name', with: @user.first_name
      s.fill_in 'last_name', with: @user.last_name
      s.fill_in 'email', with: @user.email
      s.fill_in 'password', with: @user.storepassword
      s.execute_script(%{$("#create-customer .action_button").click()});
      begin
        s.find(".#customer_detail")
        s.click_on'Account'
        @loyalty_programs_user.update_attributes(account_number: "N/A", points: s.find('.email .swell-point-balance').text.to_f, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        s.find('.errors')
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.errors').text)
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "Oops, something went wrong. we'r unable to create your account. Please try again in 10 minutes")
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end