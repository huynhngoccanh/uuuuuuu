#   require "#{Rails.root}/lib/crawler_jobs/capybara_with_phantom_js"
# module CrawlerJobs
#   class SignupCrawler
#      include ::CapybaraWithPhantomJs
# #    require 'rspec/rails'
# #    require 'capybara'
# ##    require 'capybara/dsl'
# ##    #require 'debugger'
# ##    require 'phantomjs' # <-- Not required if your app does Bundler.require automatically (e.g. when using Rails)
# ##    require 'database_cleaner'
# #    require 'capybara/poltergeist'
# ##    require 'rubygems'
# #    require 'capybara/rspec'
# ##    require "open-uri"
# ##    require 'capybara/poltergeist'
# #    require 'phantomjs'
# #    include Capybara::DSL
# #   options = {  window_size: [1280, 600], js_errors: false, timeout: 5000, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }
# ####
# #     Capybara.register_driver(:poltergeist) do |app|
# #       Capybara::Poltergeist::Driver.new(app, options)
# #     end
# #
# ##    
# ##    
# #     Capybara.current_driver = :poltergeist
# #     Capybara.javascript_driver = :poltergeist
# ##
# #    Capybara.configure do |c|
# #       c.javascript_driver = :poltergeist
# #       c.default_driver = :poltergeist
# #       c.app_host = "http://localhost:3000"
# #    end
# #    
    
#   def initialize
#     new_session
#   end
#       def best_buy email, password
#         visit 'https://www-ssl.bestbuy.com/identity/global/createAccount'
#         sleep(5)
#    #     visit 'http://www.bestbuy.com/'
#    #     select "United States - English", :from => "select_locale"
#    #     find(:xpath, '//*[@id="intl_english"]/div[1]/div/div[1]/img').click
#         # main = page.driver.browser.window_handles.first
#         # page.driver.browser.switch_to.window(main)
#         # fill_in 'email', with: email
#         # click_button 'Sign Up'
#   #      last_handle = page.driver.browser.window_handles.last
#   #     page.driver.browser.switch_to.window(last_handle)
#  #       find(:class, 'close').click
#       #  find_link('Sign In').trigger('click')
#   #      page.driver.browser.switch_to.alert.dismiss
#   #      find_link('Sign In').trigger('click')
#   #      fill_in 'fld-e', with: email
#   #      fill_in 'fld-p1', with: password
#         # page.driver.browser.switch_to.alert.accept
#         # fill_in 'ctl00_mainContentPlaceHolder_signIn_email', email
#         # fill_in 'ctl00_mainContentPlaceHolder_signIn_password', "password"
#   #      find_button('Sign In').trigger('click')
#   #      find_link('Create one').trigger('click')

#         fill_in 'fld-firstName', with: 'ali'
#         fill_in 'fld-lastName', with: "hassan"
#         fill_in 'fld-e', with: email
#         fill_in 'fld-p1', with: password
#         fill_in 'fld-p2', with: password
#         fill_in 'fld-phone', with: "456-436-6456"
#         find_button('Create an Account').trigger('click')
#         # changed the DOM structure
#       end

#       def thrifty email, password
#         visit 'https://www.thrifty.com/'
#         fill_in 'pagetitle_0_EmailAddressTextBox', with: email
#         sleep(5)
#         find(:xpath, '//*[@id="pagetitle_0_EmailSignUpButton"]').trigger('click')
#         sleep(5)
#         find(:xpath, '//*[@id="content_0_SubmitSitecoreImageButton"]').trigger('click')
#       end


#       def gnc email, password
     
#       #  visit 'https://www.gnc.com/checkout/index.jsp?process=login'
#       visit 'https://www.gnc.com/coreg/index.jsp?step=register'
#        # sleep(20)
#       #  click_link('Register')
#        # find(:xpath, '//*[@id="login-register"]/p/a[2]').trigger('click')
#        # find(:xpath, '//*[@id="emailAddExmpl"]').set(email)
#         #fill_in 'emailAddExmpl', with: email
#         fill_in 'emailId', with:email
#         fill_in 'passwrd', with: password
#         fill_in 'confPasswrd', with: password
#         find_button('signUpButton').trigger('click')
#       end

#       def petco email, password
#         visit 'https://secure.petco.com/Secure/newslettersignup.aspx'
#         find(:xpath, '//*[@id="lnkYourAccount"]').trigger('click')
#         sleep(5)
#         fill_in 'txtNewUserName', with: email
#         find_link('btnContinue').trigger('click')
#         fill_in 'txtFirstName', with: 'kevin'
#         fill_in 'txtLastName', with: 'kevin'
#         fill_in 'txtEmailAddress', with: email
#         fill_in 'txtConfirmEmail', with: email
#         fill_in 'txtNewPassword', with: password
#         fill_in 'txtConfirmPassword', with: password
#         #debugger
#         #button is diabled not working
#         find(:xpath, '//*[@id="LinkNo"]').trigger('click')
#         sleep(5)
#         #debugger
#         find(:xpath, '//*[@id="btnRegister"]/div').trigger('click')

#       end

#       def dicks_sports email, password
        
#         #byebug
        
#         visit "https://www.dickssportinggoods.com/checkout/index.jsp?process=login&ab=Header_MyAccount"
#   #      fill_in 'emailId', with: email
#   #      fill_in 'passwd', with: password
#   #      find(:xpath, '//*[@id="frame"]/table[3]/tbody/tr/td[1]/table/tbody/tr[2]/td/input[3]').trigger('click')
#   #      if current_url == "https://www.dickssportinggoods.com/checkout/index.jsp?process=login"
#           fill_in 'emailAddExmpl', with: email
#           fill_in 'passwrd', with: password
#           fill_in 'confPasswrd', with: password
#           find_button('signUpButton').trigger('click')
#   #     end
#       end

#       def gap email, password
#         visit 'https://secure-www.gap.com/profile/validate_sign_in.do'
#         fill_in 'newEmailAddress', with: email
#         find_button('registerButton').trigger('click')
#         fill_in 'password', with: password
#         fill_in 'retypePassword', with: password
#         fill_in 'passwordHint', with: 'pa'
#         fill_in 'firstName', with: 'kevin'
#         fill_in 'lastName', with: 'brothers'
#         find_button('registrationSubmitButton').trigger('click')
#       end


#       def city_sports email, password
        

#          #byebug
         
        
        
#         #click_button 'Register'
#         visit 'https://www.citysports.com/Secure/CreateAccount.aspx'
#         #find_button('ctl00_MainContent_Image1').trigger('click')
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_FirstName", with: 'kevin'
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_LastName", with: 'brothers'
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_UserName", with: email
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_textBoxConfirmEmail", with: email
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_Password", with: password
#         fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_ConfirmPassword", with: password
#         select "What city were you born in?", from: "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_Question"
#         fill_in 'ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_Answer', with: 'lahore'
#         find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[1]/option[2]').trigger('click')
#         find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[2]/option[4]').trigger('click')
#         find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[3]/option[26]').trigger('click')

#         find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_Gender"]/option[2]').trigger('click')
#         # find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[1]/option[6]').select_option
#         # find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[2]/option[3]').select_option
#         # find(:xpath, '//*[@id="ctl00_MainContent_CreateUserWizard1"]/tbody/tr[1]/td/table/tbody/tr/td/div[3]/div[1]/div[10]/span[2]/select[3]/option[27]').select_option
#         find_button('ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_Createuser').trigger('click')
#       end 


#       def famous_footwear email, password
        

       
#         visit 'https://secure.famousfootwear.com/Profiles/CreateAccount3.aspx'
#         #find_button('ctl00_MainContent_Image1').trigger('click')
        
    
  
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtFirstName", with: 'kevin'
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtLastName", with: 'brothers'
        
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtZip", with: "99801"
        
#         #fill_in "ctl00_cphPageMain_ucCustomerInfo_txtFirstName", with: 'kevin'
#         #fill_in "ctl00_cphPageMain_ucCustomerInfo_txtLastName", with: 'brothers'
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtEmailAddress", with: email
#         #fill_in "ctl00_MainContent_CreateUserWizard1_CreateUserStepContainer_textBoxConfirmEmail", with: email
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtPassword", with: password
#         fill_in "ctl00_cphPageMain_ucCustomerInfo_txtConfirmPassword", with: password
#         select "In which city were you born?", from: "ctl00_cphPageMain_ucCustomerInfo_ddlPasswordQuestion"
#         sleep(5)
#         fill_in 'ctl00_cphPageMain_ucCustomerInfo_txtPasswordAnswer', with: 'lahore'
#         #click_button('ctl00_cphPageMain_imgBtnCreate')
#        # byebug
#         click_on("ctl00_cphPageMain_imgBtnCreate")
        
 
#       end

#       def foot_locker email, password
#         visit "https://www.footlocker.com/account/default.cfm?action=accountCreate&createCoreMetricsTag=true"
#         fill_in "email", with: email
#         fill_in "password", with: password
#         fill_in "confirmPassword", with: password
#         select "August", :from => "txtBirthdateMM"
#         select "15", :from => "txtBirthdateDD"
#         select "1989", :from => "txtBirthdateYY"
#         # select "US", :from => "bill_countrySelect"
#         fill_in "billFirstName", with: "kevin"
#         fill_in "billLastName", with: "brothers"
#         fill_in "billStreet1", with: "52 Catesby Lane Bedford"
#         fill_in "bill_uszip", with: "99801"
#         fill_in "billCity", with: "Juneau, AK"

#         fill_in "billPhone", with: "6034710021"
#         #select "US", :from => "shipCountry"
#         fill_in "shipFirstName", with: "kevin"
#         fill_in "shipLastName", with: "brothers"
#         fill_in "shipStreet1", with: "52 Catesby Lane Bedford"
#         fill_in "ship_uszip", with: "99801"
#         fill_in "shipCity", with: "Anchorage"
#         select "Alaska", :from => "shipstate"
#         fill_in "shipPhone",with:  "6037318209"
#         find_button("Continue Button").trigger('click')
#         #click_button 'Continue Button'
#       end



#       def modells email, password
#         visit 'https://www.modells.com/account/login.do?method=view'
#         find(:xpath, '//*[@id="mainContentWrapper"]/table/tbody/tr/td[2]/div[3]/table/tbody/tr/td[2]/table/tbody/tr/td/div[5]/input').trigger('click')
#         fill_in "customerEmail", with: email
#         fill_in "loginPassword", with: password
#         fill_in "loginPasswordConfirm", with: password
#         select "What is your city of birth?", :from => "customer.hint"
#         fill_in "customer.hintAnswer", with: "Lahore"
#         #click_button 'Continue'
#         puts "executed"
#         find_button('Continue').trigger('click')
#         fill_in "billContact.person.firstName", with: "ali"
#         fill_in "billContact.person.lastName", with: "hassan"
#         fill_in "billContact.address.street1", with: "52 Catesby Lane Bedford"
#         fill_in "billContact.address.city", with: "Anchorage"
#         select "AK-Alaska", from: "billContact.address.state"
#         fill_in "billContact.address.postalCode", with: "99801"
#         fill_in "billContact.phone1", with: "6037318209"
#         find_button('Continue').trigger('click')
#         #select "AL", :from => "billstate"
#       end


#       def sports_authority email, password
#         visit 'https://www.sportsauthority.com/checkout/index.jsp?process=login'
#         sleep(5)
#         click_link('My Account')
#         sleep(5)
#         fill_in "emailAddExmpl", with: email
#         fill_in "passwrd", with: password
#         fill_in "confPasswrd", with: password
#         find('#signUpButton').click
#         select "Male", from: "Gender"
#         select "March", from: "BMonth"
#         select "15", from: "BDay"
#         find(:xpath, '//*[@id="checkoutTable"]/form/table/tbody/tr/td[1]/input[3]').trigger("click")
#       end
      
#       def target email, password
        
#         Capybara.current_driver = :webkit
#         Capybara.javascript_driver = :webkit
            
#         visit 'https://gam-secure.target.com/gam-webapp/create-account'      
#         fill_in "firstName", with: "kevin"
#         fill_in "lastName", with: "brothers"
#         fill_in "logonId", with: email
#         fill_in "logonPassword", with: password
#         click_button('CreateAccount')
        
#         Capybara.use_default_driver
#         Capybara.javascript_driver = :poltergeist
      
#       end
#       def kmart email, password
        
#         #byebug
        
#         #find_link('or create an account >').trigger('click')
#       #  visit 'https://gam-secure.target.com/gam-webapp/create-account'
#         visit 'http://www.kmart.com/'
#       #  click_link('registerTablet')
#         #page.all(:css, 'label#remMe.checkboxRounded').first.click()
        
#       #  page.all(:css, 'a#registerTablet').first.click()
#       #  page.all(:css, 'a.registerTablet').first.click()

        
#         sleep(5)
        
#         fill_in "email", with: email
#         fill_in "emailConfirm", with: email
#         fill_in "password", with: password
        
#         click('')
       
# #        fill_in "firstName", with: "kevin"
# #        fill_in "lastName", with: "brothers"
# #        fill_in "logonId", with: email
# #        fill_in "logonPassword", with: password
# #        find_button('create an account').trigger('button')
#       end
#       def shopn_save email, password
#         visit "https://www.shopnsave.com/"
#         find_link('Sign In').trigger('click')
#         fill_in 'ss-email-input', with: email
#         fill_in 'ss-password-login', with: password
#         find_button('Sign in').trigger('click')
#         if page.current_url == "https://www.shopnsave.com/?"

#           find_link('Sign up!').trigger('click')
#           #visit 'https://www.shopnsave.com/tools/signup.html >'
#           fill_in "ss-email-input", with: email
#           fill_in "ss-password-login", with: password
#           # fill_in "lastName", with: "brothers"
#           # fill_in "logonId", with: email
#           # emailfill_in "logonPassword", with: "Password1"
#           find_button('Continue').trigger('click')
#         end

#       end
#       def virgin_america email, password
#         visit 'https://www.virginamerica.com/elevate-frequent-flyer/sign-up'
#         fill_in "email", with: email
#         fill_in "ss-password-login", with: password
#         fill_in "lastName", with: "brothers"
#         fill_in "logonId", with: email
#         fill_in "logonPassword", with: password
#         find_button('create an account').trigger('click')
#       end
#       def safe_way email, password
#         visit 'https://www.safeway.com/ShopStores/RSS-Forms-UserRegistrationForm.page?goto=http://www.safeway.com/#/'
#         fill_in 'PhoneNumber', with: '+123456780'
#         fill_in 'EmailAddress', with: email
#         fill_in 'ConfirmEmailAddress', with: email
#         fill_in 'Password', with: password
#         fill_in 'ConfirmPassword', with: password
#         select 'What is your high school mascot?', from: 'securityQuestions'
#         fill_in 'securityAnswer', with: 'city school'
#         fill_in 'ZipCode', with: '54000'
#         find(:xpath, '//*[@id="app-view"]/section/form/div[1]/fieldset[7]/div/input[1]').set(true)
#         find_button('Continue').trigger('click')
#       end
#       def walgreens email, password
        

#       #  visit "https://www.walgreens.com/login.jsp"
#      #  sleep(5)
#    #    fill_in 'userName', with: email
#    #     fill_in 'password',with: password
#    #    find_button('Sign In').trigger('click')
#    #     if page.title == "Sign In or Register to Get Started Using Walgreens.com | Walgreens"
                      
#         #  find_button('wag-registerwid-registerbutton').trigger('click')
#         #  sleep(10)
                  
#         #  find_button('wag-regoptions-signupforbasic').trigger('click')
        
          
#           visit 'https://www.walgreens.com/register/regpersonalinfo.jsp'
#           sleep(10)
#           fill_in 'wag-regform-firstname', with: 'kevin'
#           fill_in 'wag-regform-lasttname', with: 'brothers'
#           fill_in 'wag-regform-email', with: email
#           fill_in 'wag-regform-password', with: password
#           #find_button('wag-regform-submit').trigger('click')
#           click_button('wag-regform-submit')

#     #    end
#       end
#       def national_car email, password
        
        
#         #byebug
                
#         visit "https://www.nationalcar.com/en_US/car-rental/loyalty/enrollment/enter-your-details.html?accepttermsandconditions=true"
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_firstName', with: 'ali'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_lastName', with: 'hassan'
        
#         select 'United States', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_issuingCountry'
        
#         sleep(5)
        
#         select '08', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_month'
#         select '31', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_day'
#         select '1989', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_birthDate_year'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_licenseNumber', with: '90890786590'
        
       
        
#         select 'Alaska', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_issuingStateProvince'
#         select '02', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_month'
#         select '02', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_day'
#         select Date.today.year+1, from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_expirationDate_year'
       
#        # click_link('_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_submit')
#         find(:xpath, '//*[@id="_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_submit"]').click
#        #    page.all(:css, 'dl#buttons._content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_submit').first.click()
#         #####################################
        
#         sleep(5)
                  
#        # find(:xpath, '//*[@id="_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_enter_your_details_jcr_content_cq_colctrl_lt20_c0_yourinformation_submit"]').click
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_username', with: 'alihassan123'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_password', with: password
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_verifyPassword', with: password
#         select 'WHAT IS YOUR FAVORITE COLOR?', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_securityQuestionCode'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_securityAnswer', with: 'black'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_emailAddress', with: email
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_addressLine1', with: '52 Catesby Lane Bedford'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_city', with: 'Bedford'
#         select 'United States',from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_country'
#         select 'Alaska', from: '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_stateProvince'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_postalCode', with: '99801'
#         fill_in '_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_phoneNumber0', with: '6034710021'
#         click_link('_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_up_your_account_jcr_content_cq_colctrl_lt20_c0_youraccount_submit')
#         sleep(5)
       
#         click_link('_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_select_your_preferences_jcr_content_cq_colctrl_lt20_c0_rentalpreferences_submit')
    
#         sleep(5)
#         page.choose('#protectionCountryPreference[US-RSP]_2')
#         page.choose('#protectionCountryPreference[US-SLI]_2')
#         page.choose('#protectionCountryPreference[US-LDW1]_2')
#         page.choose('#protectionCountryPreference[US-PAI_PEC]_2')
#         page.choose('#protectionCountryPreference[CA-RSP]_2')
#         page.choose('#protectionCountryPreference[CA-PAI_PEC]_2')
#         page.choose('#protectionCountryPreference[CA-LDW1]_2')
#         page.choose('#protectionCountryPreference[CA-POM]_2')
        
#         sleep(5)
#         click_link('_content_nationalcar_com_en_US_car_rental_loyalty_enrollment_set_your_rental_extras_jcr_content_cq_colctrl_lt20_c0_rentalextras_submit')
        
        
#       end
#       def home_depot email, password
#         visit "http://www.homedepot.com/b/Electrical-Home-Automation/N-5yc1vZc1jw"
#    #     find_link('Sign In').trigger('click')
#    #     fill_in 'email_id', with: email
#    #     fill_in 'password', with: password
#    #     find_button('SIGN IN').trigger('click')
   
#        # byebug
#     #    if find(:xpath, '//*[@id="userLogin"]/div[2]/div').text == "Email format is invalid. Please enter a valid email address."
#     #      find(:xpath, '//*[@id="tabs"]/ul/li[3]/a').click
    
#           sleep(5)
          
#           find_link('Register').trigger('click')
          
#           sleep(5)
         
#           fill_in 'dualSignIn-firstName', with: 'ali'
#           fill_in 'dualSignIn-lastName', with: "hassan"
#           fill_in 'dualSignIn-zipcode', with: "54000"
#           fill_in 'dualSignIn-registrationEmail', with: email
#           fill_in 'dualSignIn-registrationPassword', with: password
#           fill_in 'dualSignIn-confirmPassword', with: password
#           find_button('dualSignIn-Register').trigger('click')
#           #find(:xpath, '//*[@id="dualSignIn-Register"]').click
#    #     end

#       end
#       def sears email, password
#         visit "http://www.shopyourway.com/sears"
#         find(:xpath, '//*[@id="open-registration-form"]/span').trigger('click')
#         #  debugger
#         fill_in 'email', with: email
#         fill_in 'password', with: password
#         find(:xpath, '//*[@id="register-form"]').trigger('click')
#         fill_in 'first-name', with: "first"
#         fill_in 'last-name', with: "last"


#         find_button('create-new-membership').trigger('click')
#         #find(:xpath, '//*[@id="universalSignInBtns"]/button[1]').click
#       end

#       def ace_hardware email, password
             
#           visit "https://www.acehardware.com/checkout/index.jsp?process=login"

#           find_link('closePopup').trigger('click')
          
#           find(:xpath, '//*[@id="myAcctHeader"]/a[1]').trigger('click')
         
#           sleep(50)
   
#            fill_in 'emailAddExmpl', with: email
#            fill_in 'passwrd', with: password
#            fill_in 'confPasswrd', with: password          
#            find_button('signUpButton').trigger('click')
           
#       end

#       def stop_and_shop email, password
#         #   find_link('sign up').trigger('click')
#         visit 'https://stopandshop.com/registration/?_requestid=239886'
#         find_link('I need a Stop & Shop Card').trigger('click')
#         fill_in 'firstName', with: 'ali'
#         fill_in 'lastName', with: 'hassan'
#         fill_in 'email', with: email
#         fill_in 'password', with: password
#         #debugger
#         #find(:xpath, '//*[@id="security-questions_chosen"]/a').find(:xpath, '//*[@id="security-questions-What_is_your_favorite_drink_"]').set('What is your favorite drink?')
#         #select "What is your favorite drink?", from: 'security-questions_chosen'
#         find(:xpath, '//*[@id="security-questions"]/option[4]').trigger('click')
#         fill_in 'security-answer', with: 'redwine'
#         fill_in 'address', with: '52 Catesby Lane Bedford'
#         fill_in 'city', with: 'Bedford'
#         find(:xpath, '//*[@id="state"]/option[3]').trigger('click')
#         #select 'Alaska', from: 'state_chosen'
#         fill_in 'zip-code', with: '99801'
#         find(:xpath, '//*[@id="card-signup-form"]/ul/li[3]/ul/li[2]/ul/li[6]/label').click
#         find(:xpath, '//*[@id="storeid"]/option[3]').trigger('click')
#         find(:xpath, '//*[@id="registration-step4-next-button"]').trigger('click')
#       end
#       def kroger email, password
#         visit 'https://www.kroger.com/account/create'
#         find('#email').set(email)
#         find(:xpath, '//*[@id="confirmEmail"]').set(email)

#         fill_in 'password', with: password
#         fill_in 'confirmPassword', with: password
#         fill_in 'preferredStoreLocation', with: '99801'
#         find(:xpath, '//*[@id="submitButton"]').trigger('click')
#       end
#       def winn_dixie email, password
             
#         visit "https://www.winndixie.com/Registration"
#         fill_in 'txtBoxEmail', with: email
#         fill_in 'txtBoxPassword', with: password
#         fill_in 'txtFirstName', with: 'kevin'
#         fill_in 'txtLastName', with: 'brothers'
#         fill_in 'txtAddressMain', with: '52 Catesby Lane Bedford'
#         fill_in 'txtCity', with: 'Bedford'
#         select 'AL', from: 'ddlCity'
#         fill_in 'txtZipCode', with: '98001'
#         page.all(:css, 'label#remMe.checkboxRounded').first.click()
#         #check 'AllTextDate_License'
#         find_button('webcontent_1_btnSubmit').trigger('click')
#       end



#       def food_lion email, password
        
#        # byebug
        
#         visit "https://www.foodlion.com/registration/"
#         fill_in 'mvpSignupFirstName', with: 'kevin'
#         fill_in 'mvpSignupLastName', with: 'brothers'
#         fill_in 'mvpSignupAddress', with: '52 Catesby Lane Bedford'
#         fill_in 'mvpSignupCity', with: 'Bedford'
#         select 'Alabama', from: 'dk0-state'
#         #find(:xpath, '//*[@id="dk0-combobox"]').find(:xpath, '//*[@id="dk0-AK"]').set(:with, 'Alaska')
#         #select "Alaska", from: 'dk0-combobox'
#         fill_in 'mvpSignupZip', with: '98001'
#         fill_in 'mvpSignupPhone', with: '6034710021'
#         fill_in 'mvpSignupEmail', with: email
#         fill_in 'mvpSignupPass', with: password
#         fill_in 'pw2', with: password
#         choose 'noMvpCard'
#         find(:xpath, '//*[@id="fl-mvpAccountForm"]/div[1]/div[2]/div[5]/label/div').set(true)
#         #check 'mvpSignupAgree'
#         find(:xpath, '//*[@id="fl-mvpAccountForm"]/div[2]/div/input').click
#       end
#       def united email, password
#         #find_link('ctl00_ContentInfo_lnkEnroll').trigger('click')
#         visit 'https://www.united.com/web/en-US/apps/account/enroll.aspx'
#         select "Mr.", from: 'ctl00_ContentInfo_Name_cboTitle_cboTitle'
#         select "Male", from: 'ctl00_ContentInfo_ucGender_cboGender'
#         fill_in 'ctl00_ContentInfo_Name_FName_txtFName', with: 'kevin'
#         fill_in 'ctl00_ContentInfo_Name_MName_txtMName', with: 'kevin'
#         fill_in 'ctl00_ContentInfo_Name_LName_txtLName', with: 'Brothers'
#         fill_in 'ctl00_ContentInfo_ucBirthDate_txtDOB', with: '08/12/1965'
#         choose "ctl00_ContentInfo_AddressType_rdoAddTypeHome"
#         fill_in 'ctl00_ContentInfo_Address_address1_txtAddress1', with: '52 Catesby Lane Bedford'
#         fill_in 'ctl00_ContentInfo_Address_city_txtCity', with: 'Juneau, AK'
#         fill_in 'ctl00_ContentInfo_Address_state_txtState', with: 'Alaska'
#         fill_in 'ctl00_ContentInfo_Address_zip_txtZip', with: '99801'
#         fill_in 'ctl00_ContentInfo_HomePhone_txtNumber_txtPhone', with: '6034710021'
#         fill_in 'ctl00_ContentInfo_BusinessPhone_txtNumber_txtPhone', with: '6034710021'
#         fill_in 'ctl00_ContentInfo_Email_txtEmail', with: email
#         fill_in 'ctl00_ContentInfo_NewPin_txtNewPin_txtNewPin', with: '2121'
#         fill_in 'ctl00_ContentInfo_NewPin_txtConfPin_txtConfPin', with: '2121'
#         fill_in 'ctl00_ContentInfo_UsernamePassword_username_txtUsername', with: 'kevinbrothers'
#         fill_in 'ctl00_ContentInfo_UsernamePassword_password_txtPassword', with: password
#         fill_in 'ctl00_ContentInfo_UsernamePassword_passwordRetype_txtPassword', with: password
#         fill_in 'ctl00_ContentInfo_PINPasswordReminder_PINReminder1_txtPINReminder', with: password
#         fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_Question_txtSecurity', with: 'what is my favourit colour?'
#         fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_Answer_txtSecurity', with: 'black'
#         fill_in 'ctl00_ContentInfo_SecurityQuestionAnswer_AnswerReType_txtSecurity', with: 'black'
#         find_button('ctl00_ContentInfo_btnEnroll').trigger('click')
#       end
#       def delta email, password
       
#         user_name=email.remove "@",".com","."
#         user_name=user_name.gsub!(/\d\s?/, "")
        
#         #find(:xpath, '//*[@id="loginnav"]/div/div[1]/span[3]/a').click
#         visit 'https://www.delta.com/profile/enrolllanding.action'
#         select 'Mr', from: 'basicInfoTitle'
#         fill_in 'basicInfoFirstName', with: 'kevin'
#         fill_in 'basicInfoLastName', with: user_name
#         select 'Male', from: 'basicInfoGender'
#         select 'August', from: 'basicInfoMob'
#         select '15', from: 'basicInfoDob'
#         select '1989', from: 'basicInfoYob'
#         select 'Home', from: 'aType-1'
        
#         select 'United States', from: 'countryCode-1'
#         fill_in 'addr1-1', with: '52 Catesby Lane Bedford'
#         fill_in 'cityCountyWard-1', with: 'Bedford'
#         select 'ALASKA', from: 'stateProv-1'

#         fill_in 'postal-1', with: '99801'
#         fill_in 'requiredAreacode', with: '99801'
#         fill_in 'requiredPhoneNumber', with: '6034710021'
#         fill_in 'basicInfoEmailAddress', with: email
#         fill_in 'requiredEmail2', with: email
        
       
        
#         fill_in 'basicInfoUserName', with: user_name
#         fill_in 'basicInfoPassword', with: password
#         fill_in 'requiredEqualTo', with: password
#         select 'What is the name of your first pet?', from: 'basicInfoQuestionId1'
#         fill_in 'basicInfoAnswer1', with: 'tomy'
#         select 'What was your favorite place to visit as a child?', from: 'basicInfoQuestionId2'
#         fill_in 'basicInfoAnswer2', with: 'moon'
        
# #        within '#phoneEmailDropdown1' do
# #           find("option[value='email']").click
# #        end
#         find('#phoneEmailDropdown1').find(:xpath, 'option[2]').select_option
#         find('#phoneEmailDropdown2').find(:xpath, 'option[2]').select_option
#        # select "email", :from => "phoneEmailDropdown1"
#         #select "email", :from => "phoneEmailDropdown2"
        
# #        within '#phoneEmailDropdown2' do
# #           find("option[value='email']").click
# #        end
        
#         find_button('next').trigger('click')
#         user_name
#       end
#       def south_west email, password
        
#         visit 'https://www.southwest.com/account/enroll/enroll-member?f=zSWASWHPAA1504000zz'
#         #find_link('Enroll').trigger('click')
#         fill_in 'js-customer-first-name', with: 'kevin'
#         fill_in 'js-customer-middle-name', with: 'kevin'
#         fill_in 'js-customer-last-name', with: 'brothers'
#         select 'Aug', from: 'js-customer-birth-month'
#         select '15', from: 'js-customer-birth-day'
#         select '1968', from: 'js-customer-birth-year'
#         select 'Male', from: 'js-customer-gender'
#         fill_in 'js-contact-info-address1', with: '52 Catesby Lane Bedford'
#         fill_in 'js-contact-info-city', with: 'Juneau'
#         select 'Alaska', from: 'js-contact-info-state'
#         fill_in 'js-contact-info-zip', with: '99801'
#         fill_in 'js-us-area-code',with:  '603'
#         fill_in 'js-us-prefix-number',with:  '471'
#         fill_in 'js-us-line-number',with:  '0021'
#         fill_in 'js-contact-email',with:  email
#         fill_in 'js-contact-email-confirmation',with:  email

#         fill_in 'js-username',with:  'kevin351000'
#         fill_in 'account.password',with:  password
#         fill_in 'js-password-confirmation',with:  password
#         select 'What is the name of your first pet?', from: 'js-security-question-1'
#         fill_in 'js-security-answer-1', with: 'cat'

#         select 'What is the name of the city in which you were born?', from: 'js-security-question-2'
#         fill_in 'js-security-answer-2', with: 'Lahore'
#         check 'accept-rules-and-regulations'
        
#         #byebug
        
        
#         find_button('js-submit-button').trigger('click')
#         sleep(5)
#         click('createButton')

#       end
#       def jet_blue email, password
#         visit 'https://trueblue.jetblue.com/web/trueblue/register/'
#         fill_in  'my-eap-info-email-address', with: email
#         fill_in  'my-eap-info-confirm--email-address', with: email
#         fill_in  'my-eap-info-password', with: password
#         fill_in  'my-eap-info-confirm-password', with: password
#         #find(:xpath, '//*[@id="my-start-info"]/div[7]/button').trigger('click')
#         click_button('Continue')
#       end
#       def macys email, password 
         
#         visit 'https://www.macys.com/account/profile'
#         fill_in 'firstName', with: 'test'
#         fill_in 'lastName', with: 'user'
#         fill_in 'addressLine1', with: '52 Catesby Lane Bedford'
#         fill_in 'city', with: 'Juneau'
#         select 'Alabama', from: 'state'
        
#         fill_in 'zipcode', with: '99801'
        
#         select 'January', from: 'month'
#         select '15', from: 'date'
#         select '1990', from: 'year'
#         select 'Male', from: 'gender'

        
#         fill_in 'email', with: email
#         fill_in 'createConfirmEmail', with: email
#         fill_in 'password', with: password
#         fill_in 'confirmPassword', with: password
#         select "What is the name of a college you applied to but didn't attend?", from: 'SecurityQna'
#         fill_in 'securityAns', with: 'GC'
#         find_button('createProfileBtn').trigger('click')

#       end

#       def shurfine_markets email, password
#         visit "http://www.shurfinemarkets.com/"
#         find_link('sso_show_register').trigger('click')

#         find(:xpath, '//*[@id="rg_2"]/div').click
#         find(:xpath, '//*[@id="rl_22"]').trigger('click')
#         #find(:xpath, '//*[@id="rg_29"]/div').click
#         fill_in 'sso_reg_email', with: email
#         fill_in 'sso_reg_confirm_email', with: email
#         fill_in 'sso_reg_pword', with: password
#         fill_in 'sso_reg_confirm_pword', with: password
#         find(:xpath, '//*[@id="sso_reg_loyalty_card_msg"]').click
#         select 'Mr.', from: 'sso_reg_prefix'
#         fill_in 'sso_reg_fname', with: 'kevin'
#         fill_in 'sso_reg_lname', with: 'brothers'
#         fill_in 'sso_reg_address1', with: '52 Catesby Lane Bedford'
#         fill_in 'sso_reg_city', with: 'Juneau'
#         select 'AL', from: 'sso_reg_state'
#         fill_in 'sso_reg_zip', with: '99801'
#         check 'sso_reg_accept_tos'
#         find(:xpath, '//*[@id="sso_reg_register"]').click
#         # find_link('Login').trigger('click')
#         # fill_in 'sso_userName', with: email
#         # fill_in 'sso_pword', with: "password"
#         # find(:xpath, '//*[@id="sso_submit_login"]').click
#       end
      
#       def star_bucks email, password
        
       
        
#         visit 'https://www.starbucks.com/account/create'
#         sleep(5)
#         fill_in 'First Name', with: 'kevin'
#         fill_in 'Last Name', with: 'brothers'
#         fill_in 'Email', with: email
#         fill_in 'Create Password',with: password
#         fill_in 'Address_PostalCode', with: '99801'
       
#         #find_button('Create An Account').trigger('click')
        
#         #byebug
        
#         click_button('Create An Account')

#       end
      
#       def neiman_marcus email, password
#         visit 'https://www.neimanmarcus.com/en-pk/account/register.jsp'
#         fill_in 'registration_firstname', with: 'kevin'
#         fill_in 'registration_lastname', with: 'brothers'
#         fill_in 'registration_email', with: email
#         fill_in 'registration_email_verify', with: email
#         fill_in 'registration_password', with: password
#         fill_in 'registration_confirmpassword', with: password
#         find_button('saveRegBtn').trigger('click')
#       end
#     end
# end