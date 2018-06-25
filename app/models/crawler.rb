# class Crawler
#   require 'rubygems'
#   require 'mechanize'
#   require 'rspec/rails'
#   require 'rspec/autorun'
#   require 'capybara/rspec'
#   require 'capybara/rails'
#   require 'rspec/autorun'
#   include Capybara::DSL
# #  require 'debugger'

#   Capybara.default_driver = :selenium

#   # sites= ["http://www.sportsauthority.com/emailSignup/index.jsp?clickid=signup","http://www.target.com","http://www.sportsauthority.com","http://www.rei.com/help/subscriptions/rei-gearmail.html",
#   #         "https://www.modells.com/account/registerusername.do?method=view",
#   #         "https://www.footlocker.com/account/default.cfm?action=accountCreate",
#   #         "https://sso.shld.net/shccas/usr/regEnroll.htm?_flowId=regEnroll-flow&clienthost=www.kmart.com&target=https%3A%2F%2Fwww.kmart.com%3FstoreId%3D10151%26catalogId%3D10104&sid=4&modifyservice=true&irp=true",
#   #         ""]
#   # login_urls = ["https://www.sportsauthority.com/checkout/index.jsp?process=login",
#   #               "https://www.modells.com/account/login.do?method=view", "http://www.footlocker.com",
#   #               "https://sso.shld.net/shccas/usr/loginform.htm?_flowId=regEnroll-flow&clienthost=www.kmart.com&service=https%3A%2F%2Fwww.kmart.com%3FstoreId%3D10151%26catalogId%3D10104&sid=4&sywrequired=true&modifyservice=true&irp=true",
#   #               ""]

#   @agent = Mechanize.new
#   def self.sso_web_sites params
#     all_sites = ["www.target.com", "www.sportsauthority.com", "www.rei.com", "www.modells.com", "www.footlocker.com", "www.kmart.com"]
#     all_sites.each do |site|
#       foot_locker_sign_in params
#       modelles_login params
#       rei_login params
#       sportsauthority_login params
#     end
#   end

#   ##################################### footlocker ssi starts ################################################
#   def self.foot_locker_sign_in params
#     page=@agent.get('https://www.footlocker.com/account/default/')
#     page.forms[2].email = params[:email]
#     page.forms[2].password = params[:password]
#     res = page.forms[2].submit
#     unless res.title == "Foot Locker Account Sign In"
#       foot_locker_sign_up params
#     end
#   end
#   def self.foot_locker_sign_up params
#     sign_up = @agent.get 'https://www.footlocker.com/account/default.cfm?action=accountCreate&createCoreMetricsTag=true'
#     sign_up.forms[2].email = params[:email]
#     sign_up.forms[2].password = params[:password]
#     sign_up.forms[2].confirmPassword = params[:confirm_password]
#     sign_up.forms[2].billFirstName = params[:bill_first_name]
#     sign_up.forms[2].billLastName = params[:bill_last_name]
#     sign_up.forms[2].billZip = params[:bill_zip]
#     sign_up.forms[2].billCity = params[:bill_city]
#     sign_up.forms[2].billPhone = params[:bill_phone]
#     sign_up.forms[2].shipFirstName = params[:ship_first_name]
#     sign_up.forms[2].shipLastName = params[:ship_last_name]
#     sign_up.forms[2].shipStreet1 = params[:ship_street1]
#     sign_up.forms[2].shipZip = params[:ship_zip]
#     sign_up.forms[2].shipCity = params[:ship_city]
#     sign_up.forms[2].field_with(:name => "shipCountry").option_with(:value => "AU")
#     sign_up.forms[2].field_with(:name => "billState").option_with(:value => "AL")
#     sign_up.forms[2].field_with(:name => "txtBirthdateMM").option_with(:value => "4")
#     sign_up.forms[2].field_with(:name => "txtBirthdateDD").option_with(:value => "04")
#     sign_up.forms[2].field_with(:name => "txtBirthdateYY").option_with(:value => "2014")
#     sign_up.forms[2].submit
#   end
#   ##################################### footlocker ssi end #############################################

#   ##################################### modells ssi starts #############################################
#   def self.modelles_login params
#     page=@agent.get('https://www.modells.com/account/login.do?method=view')
#     page.forms[2].loginEmail = params[:email]
#     page.forms[2].loginPassword = params[:password]
#     page.forms[2].submit
#   end
#   def self.modells_sign_up params
#     page = @agent.get('https://www.modells.com/account/registerusername.do?method=view')
#   end
#   ##################################### modells ssi ends #############################################

#   ##################################### rei ssi starts #############################################
#   def self.rei_login params
#     page = @agent.get('https://www.rei.com/YourAccountLoginView?storeId=8000')
#     page.forms[1].logonId
#     page.forms[1].password
#     res= page.forms[1].submit
#     unless res.title == "Your Account - REI.com"
#       rei_sign_up params
#     end
#   end
#   def self.rei_sign_up params
#     page = @agent.get('https://www.rei.com/RegistrationView')
#     page.forms[1].firstName = params[:first_name]
#     page.forms[1].lastName = params[:last_name]
#     page.forms[1].email1 = params[:email]
#     page.forms[1].logonPassword = params[:password]
#     page.forms[1].logonPasswordVerify = params[:confirm_password]
#     page.forms[1].zipCode = params[:zip_code]
#     page.forms[1].submit
#   end
#   ##################################### rei ssi ends #############################################

#   ##################################### sportsauthority ssi starts #############################################
#   def self.sportsauthority_login params
#     page = @agent.get('https://www.sportsauthority.com/checkout/index.jsp?process=login')

#   end
#   def self.sportsauthority_sign_up params

#   end
#   ##################################### sportsauthority ssi ends #############################################
# end