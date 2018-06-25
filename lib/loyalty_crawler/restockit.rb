class LoyaltyCrawler::Restockit

  def initialize(loyalty_programs_user)
    @loyalty_programs_user = loyalty_programs_user
  end

  def get_history
    s = Capybara::Session.new(:selenium)
    begin
      s.visit "https://www.restockit.com/rewards-member.aspx?"
      s.find('#close-wisepop-51326').click
      s.fill_in'ctl00_rsiBodyContent_txtEmail', with: @loyalty_programs_user.account_id
      s.find('#ctl00_rsiBodyContent_btnAccountCheck').click
      begin
        s.find('#ctl00_rsiBodyContent_txtPassword1')
        s.fill_in'ctl00_rsiBodyContent_txtPassword1', with: @loyalty_programs_user.password 
        s.find('#ctl00_rsiBodyContent_LoginButton').click
        begin
          s.find('#ctl00_rsiBodyContent_ErrorMsgLabel')
          @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_rsiBodyContent_ErrorMsgLabel').text )
        rescue
          s.find('#ff_member_iframe') 
          @loyalty_programs_user.update_attributes(account_number: "N/A", points: 200, status: "success")
        end
      rescue 
        s.find('#ctl00_rsiBodyContent_ErrorMsgLabel')
        @loyalty_programs_user.update_attributes(status: "failed", exception: s.find('#ctl00_rsiBodyContent_ErrorMsgLabel').text )
      end  
    rescue 
      @loyalty_programs_user.update_attributes(status: "failed", exception: "we'r unable to access your account")
    ensure
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
      s.visit "https://www.restockit.com/rewards-member.aspx?lpaction=enroll"
      s.find('#close-wisepop-51326').click
      s.fill_in'ctl00_rsiBodyContent_txtEmail', with: @user.email
      s.find('#ctl00_rsiBodyContent_btnAccountCheck').click
      begin
        s.find('#ctl00_rsiBodyContent_txtPassword2')
        s.fill_in 'ctl00_rsiBodyContent_txtPassword1', with: @user.storepassword
        s.fill_in 'ctl00_rsiBodyContent_txtPassword2', with: @user.storepassword
        s.find('#ctl00_rsiBodyContent_LoginButton').click
        begin
          s.find('#ff_member_iframe') 
          @loyalty_programs_user.update_attributes(account_number: "N/A", points: 200, account_id: @user.email, password: @user.storepassword, status: "success")
        rescue 
          @loyalty_programs_user.update_attributes(status: "failed", exception:'We see that you already have an account with us, please enter your password and you ll start earning points today.')
        end
      rescue
        @loyalty_programs_user.update_attributes(status: "failed", exception: 'We see that you already have an account with us, please enter your password and you ll start earning points today.')
      end 
    rescue Exception => e
      @loyalty_programs_user.update_attributes(status: "failed", exception: "We're sorry, there's a problem for login account try later")
    ensure
      p "Done"
    end
  end 

end