# To execute this code, you require the rainforest_ruby_runtime. https://github.com/rainforestapp/rainforest_ruby_runtime
#
# The best way to get started is to have a look at our sample tests here:
# https://github.com/rainforestapp/sample-capybara-test
#
# Please only edit code within the `step` blocks.
#
# You can use any RSpec 3 assertion and Capybara method

include Capybara::DSL
Capybara.default_driver = :selenium
email = "arbaz.sajid@arkhitech.com"

describe "footlocker" do
  context 'footlocker cases' do
  it 'checks the footlocker' do
      visit "https://www.footlocker.com/account/default/"
      fill_in 'account_access_email_address', with: email
      fill_in 'account_access_password', with: "password"
      click_button "btn_myacct_log_in"
      if page.title == "Foot Locker Account Sign In"
        visit "https://www.footlocker.com/account/default.cfm?action=accountCreate&createCoreMetricsTag=true"
        fill_in "email", with: email
        fill_in "password", with: "password1"
        fill_in "confirmPassword", with: "password1"
        select "August", :from => "txtBirthdateMM"
        select "15", :from => "txtBirthdateDD"
        select "1989", :from => "txtBirthdateYY"
        # select "US", :from => "bill_countrySelect"
        fill_in "billFirstName", with: "kevin"
        fill_in "billLastName", with: "brothers"
        fill_in "billStreet1", with: "52 Catesby Lane Bedford"
        fill_in "bill_uszip", with: "99801"
        fill_in "billCity", with: "Juneau, AK"

        fill_in "billPhone", with: "6034710021"
        #select "US", :from => "shipCountry"
        fill_in "shipFirstName", with: "kevin"
        fill_in "shipLastName", with: "brothers"
        fill_in "shipStreet1", with: "52 Catesby Lane Bedford"
        fill_in "ship_uszip", with: "99801"
        fill_in "shipCity", with: "Anchorage"
        select "Alaska", :from => "shipstate"
        fill_in "shipPhone",with:  "6037318209"
        click_button 'Continue Button'
        sleep(8)
        #select "AL", :from => "billstate"
      end
      sleep(8)
    end
  end
end
describe "modells" do
  context 'modells cases' do
  it 'checks the modells sign in and signup' do
      visit "https://www.modells.com/account/login.do?method=view"

      fill_in 'loginEmail', with: email
      fill_in 'loginPassword', with: "password"
      click_button "Sign In"
      if page.current_url == "https://www.modells.com/account/login.do?method=submit"
        click_button 'Register'

        #visit "https://www.modells.com/account/registerusername.do?method=view"
        fill_in "customerEmail", with: email
        fill_in "loginPassword", with: "password1"
        fill_in "loginPasswordConfirm", with: "password1"
        select "What is your city of birth?", :from => "customer.hint"
        fill_in "customer.hintAnswer", with: "Lahore"
        click_button 'Continue'

        fill_in "billContact.person.firstName", with: "ali"
        fill_in "billContact.person.lastName", with: "hassan"
        fill_in "billContact.address.street1", with: "52 Catesby Lane Bedford"
        fill_in "billContact.address.city", with: "Anchorage"
        select "AK-Alaska", from: "billContact.address.state"
        fill_in "billContact.address.postalCode", with: "99801"
        fill_in "billContact.phone1", with: "6037318209"

        click_button 'Continue'
        sleep(8)
        #select "AL", :from => "billstate"
      end
      sleep(8)
    end
  end
end
describe "sportsauthority" do
  context 'sportsauthority cases' do
  it 'checks the sportsauthority sign in and signup' do
      visit "https://www.sportsauthority.com/checkout/index.jsp?process=login"
      click_link 'My Account'
      fill_in 'emailId', with: email
      fill_in 'passwd', with: "password"
      find(:xpath, '//*[@id="checkoutTable"]/tbody/tr/td/table[3]/tbody/tr/td[1]/table/tbody/tr[2]/td/input[3]').click
      if page.current_url == "https://www.sportsauthority.com/checkout/index.jsp?process=login"
        click_button 'Register'
        fill_in "emailAddExmpl", with: email
        fill_in "passwrd", with: "password1"
        fill_in "confPasswrd", with: "password1"

        click_button 'signUpButton'
        sleep(5)
      end
      sleep(5)
    end
  end
  end
describe "target" do
  context 'target cases' do
  it 'checks the target sign in and signup' do
      visit "https://gam-secure.target.com/gam-webapp/login"
      fill_in 'logonId', with: email
      fill_in 'logonPassword', with: "password"
      click_button 'sign in'
      if page.current_url == "https://gam-secure.target.com/gam-webapp/login"
        click_link 'or create an account >'
        fill_in "firstName", with: "kevin"
        fill_in "lastName", with: "brothers"
        fill_in "logonId", with: email
        fill_in "logonPassword", with: "Password1#"

        click_button 'create an account'
        sleep(5)
      end
      sleep(5)
    end
  end
end
describe "kmart" do
  context 'kmart cases' do
  it 'checks the kmart sign in and signup' do
      visit "http://www.kmart.com/shc/s/dap_10151_10104_DAP_Shop+Internationally+with+Sears?countryCd=PK"
      click_link 'sign in'
      sleep(5)
      fill_in find(:xpath, '//*[@id="email"]'), with: email
      fill_in 'password', with: "password"
      click_button 'Sign In'
      if page.current_url == "https://gam-secure.target.com/gam-webapp/login"
        click_link 'or create an account >'
        fill_in "firstName", with: "kevin"
        fill_in "lastName", with: "brothers"
        fill_in "logonId", with: email
        fill_in "logonPassword", with: "Password1"
        click_button 'create an account'
        sleep(5)
      end
      sleep(5)
    end
  end
end
describe "shopnsave" do
  context 'shopnsave cases' do
  it 'checks the shopnsave sign in and signup' do
      visit "https://www.shopnsave.com/"
      click_link 'Sign In'
      sleep(5)
      fill_in 'ss-email-input', with: email
      fill_in 'ss-password-login', with: "password"
      click_button 'Sign in'
      if page.current_url == "https://www.shopnsave.com/"
        visit 'https://www.shopnsave.com/tools/signup.html >'
        fill_in "ss-email-input", with: email
        fill_in "ss-password-login", with: "password"
        fill_in "lastName", with: "brothers"
        fill_in "logonId", with: email
        fill_in "logonPassword", with: "Password1"
        click_button 'create an account'
        sleep(5)
      end
      sleep(5)
    end
  end
end
describe "virginamrerica" do
  context 'shopnsave cases' do
  it 'checks the shopnsave sign in and signup' do
    visit 'http://www.bestbuy.com/'
    select "United States - English", :from => "select_locale"
    find(:xpath, '//*[@id="intl_english"]/div[1]/div/div[1]/img').click
    # main = page.driver.browser.window_handles.first
    # page.driver.browser.switch_to.window(main)
    # fill_in 'email', with: email
    # click_button 'Sign Up'
    last_handle = page.driver.browser.window_handles.last
    #debugger
    page.driver.browser.switch_to.window(last_handle)
    find(:class, 'close').click
    click_link 'Sign In'
    sleep(10)
    page.driver.browser.switch_to.alert.dismiss
    click_link 'Sign In'
    fill_in 'fld-e', with: email
    fill_in 'fld-p1', with: 'password'
    # page.driver.browser.switch_to.alert.accept
    # fill_in 'ctl00_mainContentPlaceHolder_signIn_email', email
    # fill_in 'ctl00_mainContentPlaceHolder_signIn_password', "password"
    click_button 'Sign In'
    click_link 'Create one'

    fill_in 'fld-firstName', with: 'ali'
    fill_in 'fld-lastName', with: "hassan"
    fill_in 'fld-e', with: email
    fill_in 'fld-p1', with: "password"
    fill_in 'fld-p2', with: "password"
    fill_in 'fld-phone', with: "+12345678"
    click_button 'Create an Account'
    sleep(5)
    end
  end
end

describe "virginamrerica" do
  context 'shopnsave cases' do
  it 'checks the shopnsave sign in and signup' do
    visit "https://secure.nordstrom.com/SignIn.aspx?ReturnURL=http%3a%2f%2fshop.nordstrom.com%2f&origin=tab"
    sleep(10)
    fill_in 'ctl00_mainContentPlaceHolder_signIn_email', email
    fill_in 'ctl00_mainContentPlaceHolder_signIn_password', "password"
    click_button 'Sign In'

    fill_in 'ss-email-input', with: email
    fill_in 'ss-password-login', with: "password"
    click_button 'Sign in'
    if page.current_url == "https://www.shopnsave.com/"
      visit 'https://www.virginamerica.com/elevate-frequent-flyer/sign-up'
      fill_in "email", with: email
      fill_in "ss-password-login", with: "password"
      fill_in "lastName", with: "brothers"
      fill_in "logonId", with: email
      fill_in "logonPassword", with: "Password1"
      click_button 'create an account'
      sleep(5)
    end
    sleep(5)
    end
  end
end
describe "safeway" do
  context 'shopnsave cases' do
  it 'checks the safeway sign in and signup' do
    visit "https://www.safeway.com/ShopStores/OSSO-Login.page?goto=http%3A%2F%2Fwww.safeway.com%2F"
    fill_in 'userId', with: email
    fill_in 'password',with: 'password'
    find(:xpath, '//*[@id="SignInBtn"]').click
    if page.title == "Safeway - Sign In"
      find(:xpath, '//*[@id="RegNowBtn"]').click
      fill_in 'PhoneNumber', with: '+123456780'
      fill_in 'EmailAddress', with: email
      fill_in 'ConfirmEmailAddress', with: email
      fill_in 'Password', with: 'password'
      fill_in 'ConfirmPassword', with: 'password'
      select 'What is your high school mascot?', from: 'securityQuestions'
      fill_in 'securityAnswer', with: 'city school'
      fill_in 'ZipCode', with: '54000'
      find(:xpath, '//*[@id="app-view"]/section/form/div[1]/fieldset[7]/div/input[1]').set(true)
      click_button 'Continue'
    end
    sleep(5)
    end
  end
end
describe "walgreens" do
  context 'walgreens cases' do
  it 'checks the walgreens sign in and signup' do
    visit "https://www.walgreens.com/login.jsp"
    fill_in 'userName', with: email
    fill_in 'password',with: 'password'
    click_button 'Sign In'
    if page.title == "Sign In or Register to Get Started Using Walgreens.com | Walgreens"
      click_button 'wag-registerwid-registerbutton'
      click_button 'wag-regoptions-signupforbasic'
      fill_in 'wag-regform-firstname', with: 'ali'
      fill_in 'wag-regform-lasttname', with: 'hassan'
      fill_in 'wag-regform-email', with: email
      fill_in 'wag-regform-password', with: 'password'
      click_button 'wag-regform-submit'
    end
    sleep(5)
    end
  end
end
describe "nationalcar" do
  context 'national car cases' do
    it 'checks the national car sign in and signup' do
      visit "https://www.nationalcar.com/en_US/car-rental/loyalty/enrollment/enter-your-details.html?accepttermsandconditions=true"
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_firstName', with: 'ali'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_lastName', with: 'hassan'
      select 'United States', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_countryOfResidence'
      select '08', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_month'
      select '31', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_day'
      select '1989', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_year'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_licenseNumber', with: '90890786590'
      select 'Alaska', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_issuingStateProvince'
      select Date.today.month, from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_month'
      select Date.today.day + 1, from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_day'
      select Date.today.year, from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_year'
      select 'United States', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_issuingCountry'
      find(:xpath, '//*[@id="_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_submit"]').click
      sleep(15)
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_username', with: 'alihassan123'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_password', with: 'password'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_verifyPassword', with: 'password'
      select 'WHAT IS YOUR FAVORITE COLOR?', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_securityQuestionCode'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_securityAnswer', with: 'black'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_emailAddress', with: email
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_addressLine1', with: '52 Catesby Lane Bedford'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_city', with: 'Bedford'
      select 'United States',from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_country'
      select 'Alaska', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_stateProvince'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_postalCode', with: '99801'
      fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_phoneNumber0', with: '6034710021'
      find(:xpath, '//*[@id="_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_submit"]').click
    end
  end
end
describe "homedepot" do
  context 'homedepot car cases' do
    it 'checks the homedepot sign in and signup' do
      visit "http://www.homedepot.com/b/Electrical-Home-Automation/N-5yc1vZc1jw"
      click_link 'Sign In'
      fill_in 'email_id', with: email
      fill_in 'password', with: 'password'
      click_button 'SIGN IN'
      if find(:xpath, '//*[@id="userLogin"]/div[2]/div').text == "Email format is invalid. Please enter a valid email address."
        find(:xpath, '//*[@id="tabs"]/ul/li[3]/a').click
        fill_in 'dualSignIn-firstName', with: 'ali'
        fill_in 'dualSignIn-lastName', with: "hassan"
        fill_in 'dualSignIn-zipcode', with: "54000"
        fill_in 'dualSignIn-registrationEmail', with: 'ali.hassan.mirzaa@gmail.com'
        fill_in 'dualSignIn-registrationPassword', with: 'password123'
        fill_in 'dualSignIn-confirmPassword', with: 'password123'
        find(:xpath, '//*[@id="dualSignIn-Register"]').click
        sleep(10)
      end
    end
  end
end
describe "sears" do
  context 'sears car cases' do
    it 'checks the sears sign in and signup' do
      visit "http://www.sears.com/en_intnl/dap/shopping-tourism.html"
      sleep(10)
      #debugger
      find(:xpath, '//*[@id="gnf_holidayRewards"]/span/a').click
      click_link 'join for free'
      fill_in 'email', with: email
      fill_in 'emailConfirm', with: email
      fill_in 'password', with: 'password'
      click_button 'universalSignInBtns'
      #find(:xpath, '//*[@id="universalSignInBtns"]/button[1]').click
      #debugger
    end
  end
end
describe "acehardware" do
  context 'acehardware car cases' do
    it 'checks the acehardware sign in and signup' do
      visit "https://www.acehardware.com/checkout/index.jsp?process=login"
      click_link 'closePopup'
      click_link 'Create Account'
      fill_in 'emailId', with: email
      fill_in 'password', with: 'password'
      find(:xpath, '//*[@id="mainContent"]/table[3]/tbody/tr/td[1]/table/tbody/tr[2]/td/input[3]').click
      if page.current_url == "https://www.acehardware.com/checkout/index.jsp?process=login"
        fill_in 'emailAddExmpl', with: email
        fill_in 'passwrd', with: 'password'
        fill_in 'confPasswrd', with: 'password'
        click_button 'signUpButton'
      end
    end
  end
end
describe "stopandshop" do
  context 'stopandshop cases' do
    it 'checks the stopandshop sign in and signup' do
      visit "https://stopandshop.com/login/?_requestid=819231"

      fill_in 'username', with: email
      fill_in 'password', with: 'password'
      click_button 'login-form-standalone-button'
      #debugger
      if page.current_url == "https://stopandshop.com/login/?_requestid=819231"
        click_link 'sign up'
        click_link 'I need a Stop & Shop Card'
        fill_in 'firstName', with: 'ali'
        fill_in 'lastName', with: 'hassan'
        fill_in 'email', with: email
        fill_in 'password', with: 'password'
        select "What is your favorite drink?", from: 'security-questions_chosen'
        fill_in 'security-answer', with: 'redwine'
        fill_in 'address', with: '52 Catesby Lane Bedford'
        fill_in 'city', with: 'Bedford'
        select 'Alaska', from: 'state_chosen'
        fill_in 'zip-code', with: '99801'
        check '//*[@id="card-signup-form"]/ul/li[3]/ul/li[2]/ul/li[6]/label'
      end
    end
  end
end
describe "kroger" do
  context 'kroger cases' do
    it 'checks the kroger sign in and signup' do
      visit "https://www.kroger.com/"
      click_link 'signIn'

      fill_in 'signin-drawer-email-address', with: 'ali.hassan.mirzaa@gmail.com'
      fill_in 'signin-drawer-password', with: 'password'
      click_button 'signin-drawer-submit'
      if page.current_url == "https://www.kroger.com/"
        click_link 'Create an account'
        fill_in 'email', with: 'ali.hassan.mirzaa@gmail.com'
        fill_in 'confirmEmail', with: 'ali.hassan.mirzaa@gmail.com'
        fill_in 'password', with: 'password123'
        fill_in 'confirmPassword', with: 'password123'
        fill_in 'preferredStoreLocation', with: '99801'
        click_button 'submitButton'
      end
    end
  end
end
describe "shopnsaver" do
  context 'shopnsave cases' do
    it 'checks the shopnsave sign in and signup' do
      visit "https://www.shopnsave.com/"
      click_link 'Sign In'

      fill_in 'ss-email-input', with: 'ali.hassan.mirzaa@gmail.com'
      fill_in 'ss-password-login', with: 'password'
      click_button 'Sign in'
      if page.current_url == "https://www.shopnsave.com/"
        click_link 'Sign up!'
        sleep(10)
        #debugger
        fill_in 'ss-email-input', with: 'ali.hassan.mirzaa@gmail.com'
        sleep(10)
        fill_in 'ss-password-login', with: 'password'
        puts "yaki"
        find(:xpath, '//*[@id="ss-signup-form"]/div[4]/button').click
        find(:xpath, '//*[@id="layout"]/div[3]/div[2]/div[1]/form/div/input').set(:with, '63011')
        click_button 'Use this store'
        click_button 'Continue'
      end
    end
  end
end
describe "shopnsaver" do
  context 'shopnsave cases' do
    it 'checks the shopnsave sign in and signup' do
      visit "https://www.shopnsave.com/"
      click_link 'Sign In'

      fill_in 'ss-email-input', with: 'ali.hassan.mirzaa@gmail.com'
      fill_in 'ss-password-login', with: 'password'
      click_button 'Sign in'
      if page.current_url == "https://www.shopnsave.com/"
        click_link 'Sign up!'
        sleep(10)
        #debugger
        fill_in 'ss-email-input', with: 'ali.hassan.mirzaa@gmail.com'
        sleep(10)
        fill_in 'ss-password-login', with: 'password'
        puts "yaki"
        find(:xpath, '//*[@id="ss-signup-form"]/div[4]/button').click
        find(:xpath, '//*[@id="layout"]/div[3]/div[2]/div[1]/form/div/input').set(:with, '63011')
        click_button 'Use this store'
        click_button 'Continue'
      end
    end
  end
end
describe "winndixie" do
  context 'winndixie cases' do
    it 'checks the winndixie sign in and signup' do
      visit "https://www.winndixie.com/Registration"
      fill_in 'txtBoxEmail', with: email
      fill_in 'txtBoxPassword', with: 'password'
      fill_in 'txtFirstName', with: 'kevin'
      fill_in 'txtLastName', with: 'brothers'
      fill_in 'txtAddressMain', with: '52 Catesby Lane Bedford'
      fill_in 'txtCity', with: 'Bedford'
      select 'AL', from: 'ddlCity'
      fill_in 'txtZipCode', with: '98001'
      click_button 'webcontent_1_btnSubmit'
    end
  end
end
describe "foodlion" do
  context 'foodlion cases' do
    it 'checks the foodlion sign in and signup' do
      visit "https://www.foodlion.com/registration/"

      fill_in 'mvpSignupFirstName', with: 'kevin'
      fill_in 'mvpSignupLastName', with: 'brothers'
      fill_in 'mvpSignupAddress', with: '52 Catesby Lane Bedford'
      fill_in 'mvpSignupCity', with: 'Bedford'
      #debugger
      find(:xpath, '//*[@id="dk0-combobox"]').set(:with, 'Alaska')
      select "Alaska", from: 'dk0-combobox'
      fill_in 'mvpSignupZip', with: '98001'
      fill_in 'mvpSignupPhone', with: '6034710021'
      fill_in 'mvpSignupEmail', with: email
      fill_in 'mvpSignupPass', with: 'passsword'
      fill_in 'pw2', with: 'passsword'
      choose 'noMvpCard'
      check 'mvpSignupAgree'
      find(:xpath, '//*[@id="fl-mvpAccountForm"]/div[2]/div/input').click
    end
  end
end
describe "united" do
  context 'united cases' do
    it 'checks the united sign in and signup' do
      visit "http://www.united.com/web/en-US/apps/account/account.aspx"

      fill_in 'ctl00_ContentInfo_SignIn_onepass_txtField', with: email
      fill_in 'ctl00_ContentInfo_SignIn_password_txtPassword', with: 'password'

      click_button 'ctl00_ContentInfo_SignInSecure'
      if page.title == "Sign In | United Airlines"
        click_link 'ctl00_ContentInfo_lnkEnroll'

        select "Mr.", from: 'ctl00_ContentInfo_Name_cboTitle_cboTitle'
        select "Male", from: 'ctl00_ContentInfo_ucGender_cboGender'
        fill_in 'ctl00_ContentInfo_Name_FName_txtFName', with: 'kevin'
        fill_in 'ctl00_ContentInfo_Name_MName_txtMName', with: 'kevin'
        fill_in 'ctl00_ContentInfo_Name_LName_txtLName', with: 'Brothers'
        fill_in 'ctl00_ContentInfo_ucBirthDate_txtDOB', with: '08/12/1965'

        choose "ctl00_ContentInfo_AddressType_rdoAddTypeHome"
        fill_in 'ctl00_ContentInfo_Address_address1_txtAddress1', with: '52 Catesby Lane Bedford'
        fill_in 'ctl00_ContentInfo_Address_city_txtCity', with: 'Juneau, AK'
        fill_in 'ctl00_ContentInfo_Address_state_txtState', with: 'Alaska'
        fill_in 'ctl00_ContentInfo_Address_zip_txtZip', with: '99801'
        fill_in 'ctl00_ContentInfo_HomePhone_txtNumber_txtPhone', with: '6034710021'
        fill_in 'ctl00_ContentInfo_BusinessPhone_txtNumber_txtPhone', with: '6034710021'
        fill_in 'ctl00_ContentInfo_Email_txtEmail', with: email
        fill_in 'ctl00_ContentInfo_NewPin_txtNewPin_txtNewPin', with: '2121'
        fill_in 'ctl00_ContentInfo_NewPin_txtConfPin_txtConfPin', with: '2121'
        fill_in 'ctl00_ContentInfo_UsernamePassword_username_txtUsername', with: 'kevinbrothers'
        fill_in 'ctl00_ContentInfo_UsernamePassword_password_txtPassword', with: 'password'
        fill_in 'ctl00_ContentInfo_UsernamePassword_passwordRetype_txtPassword', with: 'password'
        fill_in 'ctl00_ContentInfo_PINPasswordReminder_PINReminder1_txtPINReminder', with: 'password'
        fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_Question_txtSecurity', with: 'what is my favourit colour?'
        fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_Answer_txtSecurity', with: 'black'
        fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_AnswerReType_txtSecurity', with: 'black'
        click_button 'ctl00_ContentInfo_btnEnroll'
      end
    end
  end
end
describe "delta" do
  context 'delta cases' do
    it 'checks the delta sign in and signup' do
      visit "http://www.delta.com/"

      fill_in 'usernm', with: email
      fill_in 'pwd', with: 'password'

      click_button 'GO'
      if page.current_url == "http://www.delta.com/"
        find(:xpath, '//*[@id="loginnav"]/div/div[1]/span[3]/a').click
        select 'Mr', from: 'basicInfoTitle'
        fill_in 'basicInfoFirstName', with: 'kevin'
        fill_in 'basicInfoLastName', with: 'brothers'
        select 'Male', from: 'basicInfoGender'
        select 'August', from: 'basicInfoMob'
        select '15', from: 'basicInfoDob'
        select '1989', from: 'basicInfoYob'
        select 'Home', from: 'aType-1'

        fill_in 'addr1-1', with: '52 Catesby Lane Bedford'
        fill_in 'cityCountyWard-1', with: 'Juneau, AK'
        select 'ALASKA', from: 'stateProv-1'

        fill_in 'postal-1', with: '99801'
        fill_in 'requiredAreacode', with: '99801'
        fill_in 'requiredPhoneNumber', with: '6034710021'
        fill_in 'basicInfoEmailAddress', with: email
        fill_in 'requiredEmail2', with: email
        fill_in 'basicInfoUserName', with: 'kevinbrothers'
        fill_in 'basicInfoPassword', with: 'password'
        fill_in 'requiredEqualTo', with: 'password'
        select 'What is the name of your first pet?', from: 'basicInfoQuestionId1'
        fill_in 'basicInfoAnswer1', with: 'cat'
        select 'What is the name of your first pet?', from: 'basicInfoQuestionId2'
        fill_in 'basicInfoAnswer2', with: 'cat'
        click_button 'COMPLETE'
      end
    end
  end
end

describe "southwest" do
  context 'southwest cases' do
    it 'checks the southwest sign in and signup' do
      visit "https://www.southwest.com/"
      click_link 'Log In'
      fill_in 'username', with: 'kevin'
      fill_in 'password', with: 'password'

      click_button 'Log In'
      if page.current_url == "https://www.southwest.com/?loginError=true&int="
        click_link 'Enroll'
        fill_in 'js-customer-first-name', with: 'kevin'
        fill_in 'js-customer-middle-name', with: 'kevin'
        fill_in 'js-customer-last-name', with: 'brothers'
        select 'Aug', from: 'js-customer-birth-month'
        select '15', from: 'js-customer-birth-day'
        select '1968', from: 'js-customer-birth-year'
        select 'Male', from: 'js-customer-gender'
        fill_in 'js-contact-info-address1', with: '52 Catesby Lane Bedford'
        fill_in 'js-contact-info-city', with: 'Juneau'
        select 'Alaska', from: 'js-contact-info-state'
        fill_in 'js-contact-info-zip', with: '99801'
        fill_in 'js-us-area-code',with:  '603'
        fill_in 'js-us-prefix-number',with:  '471'
        fill_in 'js-us-line-number',with:  '0021'
        fill_in 'js-contact-email',with:  'kevinnn@muddleme.com'
        fill_in 'js-contact-email-confirmation',with:  'kevinnn@muddleme.com'

        fill_in 'js-username',with:  'kevin351000'
        fill_in 'account.password',with:  'Pkevin123!'
        fill_in 'js-password-confirmation',with:  'Pkevin123!'
        select 'What is the name of your first pet?', from: 'js-security-question-1'
        fill_in 'js-security-answer-1', with: 'cat'

        select 'What is the name of the city in which you were born?', from: 'js-security-question-2'
        fill_in 'js-security-answer-2', with: 'Lahore'
        check 'accept-rules-and-regulations'
        click_button 'js-submit-button'
        click_button 'createButton'
        sleep(25)
      end
    end
  end
end

describe "jetblue" do
  context 'jetblue cases' do
    it 'checks the jetblue sign in and signup' do
      visit "https://book.jetblue.com/B6.auth/login?service=https%3A%2F%2Ftrueblue.jetblue.com%2Fc%2Fportal%2Flogin%3Fredirect%3D%252Fgroup%252Ftrueblue%252Fmy-trueblue-home%26p_l_id%3D10514"
      fill_in 'username', with: email
      fill_in 'password', with: 'password'
      click_link 'Sign in'
      if page.title == "Single Signon"
        click_link 'Join'
        fill_in 'my-eap-info-email-address', with: email
        fill_in 'my-eap-info-confirm--email-address', with: email
        fill_in 'password', with: 'password'
        click_button 'createButton'
        sleep(25)
      end
    end
  end
end

describe "macys" do
  context 'macys cases' do
    it 'checks the macys sign in and signup' do
      visit "https://www.macys.com/registry/wedding/registrysignin"
      first(:css, '#email').set(with: email)
      fill_in 'password', with: 'password'
      click_button 'signInButton'
      if page.title == "Registry Sign In"
        page.all('#email').last.set(email)
        fill_in 'registryId', with: 'kevinpassword123'
        click_button 'continue'
        sleep(25)
      end
    end
  end
end
#####################################################################################################################
## this site has multiple options #############
describe "shurfinemarkets" do
  context 'shurfinemarkets cases' do
    it "checks the shurfinemarkets sign in and signup using Stauffer's Market" do
      visit "http://www.shurfinemarkets.com/"
      sleep(15)
      click_link 'Login'
      fill_in 'sso_userName', with: email
      fill_in 'sso_pword', with: "password"
      find(:xpath, '//*[@id="sso_submit_login"]').click
      if page.current_url == "http://www.shurfinemarkets.com/#"
        find(:xpath, '//*[@id="sso_dialog"]/span[3]').click
        click_link 'sso_show_register'
        find(:xpath, '//*[@id="rg_29"]/div').click
        fill_in 'sso_reg_email', with: email
        fill_in 'sso_reg_confirm_email', with: email
        fill_in 'sso_reg_pword', with: 'Password3245'
        fill_in 'sso_reg_confirm_pword', with: 'Password3245'
        find(:xpath, '//*[@id="sso_reg_loyalty_card_msg"]').click
        select 'Mr.', from: 'sso_reg_prefix'
        fill_in 'sso_reg_fname', with: 'kevin'
        fill_in 'sso_reg_lname', with: 'brothers'
        fill_in 'sso_reg_address1', with: '52 Catesby Lane Bedford'
        fill_in 'sso_reg_city', with: 'Juneau'
        select 'AL', from: 'sso_reg_state'
        fill_in 'sso_reg_zip', with: '99801'
        check 'sso_reg_accept_tos'
        find(:xpath, '//*[@id="sso_reg_register"]').click
      end
      find(:xpath, '//*[@id="sso_dialog"]/span[3]').click
      click_link 'Login'
      fill_in 'sso_userName', with: email
      fill_in 'sso_pword', with: "password"
      find(:xpath, '//*[@id="sso_submit_login"]').click
    end
  end
end

describe "starbucks" do
  context 'starbucks cases' do
    it "checks the starbucks sign in and signup using Stauffer's Market" do
      visit "https://www.starbucks.com/account/signin"
      fill_in 'Username or email', with: email
      fill_in 'Password', with: "password"
      click_button 'Sign In'
      if page.current_url == "https://www.starbucks.com/account/signin"
        click_link 'Create An Account'
        fill_in 'First Name', with: 'kevin'
        fill_in 'Last Name', with: 'brothers'
        fill_in 'Email', with: email
        fill_in 'Create Password',with: "Password12#"
        fill_in 'Address_PostalCode', with: '99801'
        click_button 'Create An Account'
      end
      #debugger
    end
  end
end

describe "neimanmarcus" do
  context 'neimanmarcus cases' do
    it "checks the neimanmarcus sign in and signup using Stauffer's Market" do
      visit "https://www.neimanmarcus.com/en-pk/account/login.jsp?_requestid=81921"
      fill_in 'login_email', with: email
      fill_in 'login_password', with: "password"
      click_button 'signInBtn'
      if page.current_url == "https://www.neimanmarcus.com/en-pk/account/login.jsp?_requestid=120102"
        click_button 'Register Now'
        fill_in 'registration_firstname', with: 'kevin'
        fill_in 'registration_lastname', with: 'brothers'
        fill_in 'registration_email', with: email
        fill_in 'registration_email_verify', with: email
        fill_in 'registration_password', with: 'password'
        fill_in 'registration_confirmpassword', with: 'password'
        click_button 'saveRegBtn'
      end
    end
  end
end



# gem install selenium-webdriver -v "2.35.0"

