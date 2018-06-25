class LoyaltyCrawler::Bestbuy

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:poltergeist)
    begin
      s.visit "http://deals.bestbuy.com/"
      # s.debugger
      s.click_on'Sign In'
      s.find('.action-btn').click
      s.fill_in 'fld-e', with: @loyalty_programs_user.account_id
      s.fill_in 'fld-p1', with: @loyalty_programs_user.password
      s.click_button 'Sign In'
      begin
        # s.debugger
        s.find('.primary-wrap .profile')
        s.find('#profileMenuWrap1').click
        s.click_on'Account Home'
        @loyalty_programs_user.update_attributes(account_number: s.find(".welcome-widget__memberid").text.split(" ").last, points: s.find(".rewards-widget__points .rewards-widget__number").text, status: "success")
      rescue 
        begin
          s.find('.has-error .help-block')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.has-error .help-block').text)
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.alert__container').text)
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
      s.visit "http://deals.bestbuy.com/"
      s.click_link "Sign In"
      s.click_link "Create a My Best Buy Account"
      s.fill_in 'fld-firstName', with: @user.first_name
      s.fill_in 'fld-lastName', with: @user.last_name
      s.fill_in 'fld-e', with: @user.email
      s.fill_in 'fld-p1', with: @user.storepassword
      s.fill_in 'fld-p2', with: @user.storepassword
      s.fill_in('phone',:with=>@user.phone)
      s.fill_in('phone',:with=>@user.phone)
      s.click_on "Create an Account"
      begin
        s.find(".welcome-widget__memberid")
        @loyalty_programs_user.update_attributes(account_number: s.find(".welcome-widget__details .welcome-widget__memberid").text.split(" ").last, points: s.find(".rewards-widget__points .rewards-widget__number").text, account_id: @user.email, password: @user.storepassword, status: "success")
      rescue
        begin
          s.find('.has-error .help-block')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.has-error .help-block').text)
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('.alert__container').text)
        end
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: e.to_s)
    ensure
      s.driver.quit
      p "Done"
    end
  end 

end

# Kevin.m.brothers@gmail.com
# Belladrew1