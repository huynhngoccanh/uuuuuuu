# require 'rspec/rails'
# require 'capybara'
# require 'capybara/dsl'
# #require 'debugger'
# require 'phantomjs' # <-- Not required if your app does Bundler.require automatically (e.g. when using Rails)
# require 'database_cleaner'
# require 'capybara/poltergeist'
# require 'rubygems'
# require 'capybara/rspec'
# require "open-uri"
# require 'capybara/poltergeist'
# require 'phantomjs'
# include Capybara::DSL
# Capybara.current_driver = :poltergeist
# #Capybara.javascript_driver = :poltergeist
# options = {  window_size: [1280, 600], js_errors: false, timeout: 500, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }

# Capybara.register_driver(:poltergeist) do |app|
#   Capybara::Poltergeist::Driver.new(app, options)
# end

# Capybara.configure do |c|
#   c.javascript_driver = :poltergeist
#   c.default_driver = :poltergeist
#   #c.app_host = "http://localhost:3000"
# end
# puts "in file"

# task :ssi => :environment do
#   email = ENV['email'].split(',')[0]
#   password = ENV['email'].split(',')[1]
#   # puts 'sears'
#   # sears email, password
#   #tested
#   puts 'bestbuy'
#   begin
#     SignupCrawler::best_buy email, password
#   rescue Exception => ex
#     puts 'BAD - bestbuy'
#   end
#   puts 'shurfinemarkets'
#   begin
#     SignupCrawler::shurfine_markets email, password
#   rescue Exception => ex
#     puts 'BAD - shurfinemarkets'
#   end
#   puts 'winndixie'
#   begin
#     SignupCrawler::winn_dixie email, password
#   rescue Exception => ex
#     puts 'BAD - winndixie'
#   end

#   puts 'started dickssports'
#   begin
#     SignupCrawler::dicks_sports email, password
#   rescue Exception => ex
#     puts 'BAD - started dickssports'
#   end

#   puts 'citysports'
#   begin
#     SignupCrawler::city_sports email, password
#   rescue Exception => ex
#     puts 'BAD - citysports'
#   end
#   puts 'stopandshop'
#   begin
#     SignupCrawler::stop_and_shop email, password
#   rescue Exception => ex
#     puts 'BAD - stopandshop'
#   end
#   puts 'southwest'
#   begin
#     SignupCrawler::south_west email, password
#   rescue Exception => ex
#     puts 'BAD - southwest'
#   end
#   puts 'delta'
#   begin
#     SignupCrawler::delta email, password
#   rescue Exception => ex
#     puts 'BAD - delta'
#   end
#   puts 'united'
#   begin
#     SignupCrawler::united email, password
#   rescue Exception => ex
#     puts 'BAD - united'
#   end
#   puts 'homedepot'
#   begin
#     SignupCrawler::home_depot email, password
#   rescue Exception => ex
#     puts 'BAD - homedepot'
#   end
#   puts 'nationalcar'
#   begin
#     SignupCrawler::national_car email, password
#   rescue Exception => ex
#     puts 'BAD - nationalcar'
#   end
#   puts 'walgreens'
#   begin
#     SignupCrawler::wal_greens email, password
#   rescue Exception => ex
#     puts 'BAD - walgreens'
#   end
#   puts 'safeway'
#   begin
#     SignupCrawler::safe_way email, password
#   rescue Exception => ex
#     puts 'BAD - safeway'
#   end
#   puts 'virginamerica'
#   begin
#     SignupCrawler::virgin_america email, password
#   rescue Exception => ex
#     puts 'BAD - virginamerica'
#   end
#   puts 'kmart'
#   begin
#     SignupCrawler::kmart email, password
#   rescue Exception => ex
#     puts 'BAD - kmart'
#   end
#   puts 'sportsauthority'
#   begin
#     SignupCrawler::sports_authority email, password
#   rescue Exception => ex
#     puts 'BAD - sportsauthority'
#   end
#   puts 'fameousfootwear'
#   begin
#     SignupCrawler::fameous_footwear email, password
#   rescue Exception => ex
#     puts 'BAD - fameousfootwear'
#   end
#   puts 'foodlion'
#   begin
#     SignupCrawler::food_lion email, password
#   rescue Exception => ex
#     puts 'BAD - foodlion'
#   end
#   puts "started footlocker with #{email}"
#   begin
#     SignupCrawler::foot_locker email, password
#   rescue Exception => ex
#     puts "BAD - started footlocker with #{email}"
#   end
#   puts 'statrted neimanmarcus'
#   begin
#     SignupCrawler::neiman_marcus email, password
#   rescue Exception => ex
#     puts 'BAD - statrted neimanmarcus'
#   end
#   puts 'started shopnsave'
#   begin
#     SignupCrawler::shopn_save email, password
#   rescue Exception => ex
#     puts 'BAD - started shopnsave'
#   end
#   puts 'macys'
#   begin
#     SignupCrawler::macys email, password
#   rescue Exception => ex
#     puts 'BAD - macys'
#   end
#   puts 'jetblue'
#   begin
#     SignupCrawler::jet_blue email, password
#   rescue Exception => ex
#     puts 'BAD - jetblue'
#   end
#   puts 'kroger'
#   begin
#     SignupCrawler::kroger email, password
#   rescue Exception => ex
#     puts 'BAD - kroger'
#   end
#   puts 'started starbucks'
#   begin
#     SignupCrawler::star_bucks email, password
#   rescue Exception => ex
#     puts 'BAD - started starbucks'
#   end
#   puts "started modells"
#   begin
#     SignupCrawler::modells email, password
#   rescue Exception => ex
#     puts "BAD - started modells"
#   end
#   puts 'started petco'
#   begin
#     SignupCrawler::petco email, password
#   rescue Exception => ex
#     puts 'BAD - started petco'
#   end
#   puts 'gap'
#   begin
#     SignupCrawler::gap email, password
#   rescue Exception => ex
#     puts 'BAD - gap'
#   end
#   # puts 'citysports'
#   # citysports email, password
#   puts 'statrted gnc'
#   begin
#     SignupCrawler::gnc email, password
#   rescue Exception => ex
#     puts 'BAD - statrted gnc'
#   end
#   puts 'started thrifty'
#   begin
#     SignupCrawler::thrifty email, password
#   rescue Exception => ex
#     puts 'BAD - started thrifty'
#   end
#   puts 'acehardware'
#   begin
#     SignupCrawler::ace_hardware email, password
#   rescue Exception => ex
#     puts 'BAD - acehardware'
#   end
#   #
# end
# # methods to run single signup




# # def city
# #   visit "https://secure-oldnavy.gap.com/profile/sign_in.do?context=nav&targetURL=/"
# #   fill_in 'emailAddress', with: email
# #   fill_in 'password', with: "password1"
# #   find_button('signInButton').trigger('click')
# #   if current_url == "https://secure-oldnavy.gap.com/profile/validate_sign_in.do"
# #     #click_button 'Register'
# #     fill_in 'newEmailAddress', with: email
# #     find_button('registerButton').trigger('click')
# #     fill_in 'password', with: 'password1'
# #     fill_in 'retypePassword', with: 'password1'
# #     fill_in 'passwordHint', with: 'pa'
# #     fill_in 'firstName', with: 'kevin'
# #     fill_in 'lastName', with: 'brothers'
# #     puts 'signinup gap'
# #     find_button('registrationSubmitButton').trigger('click')
# #     puts 'signed up at gap'
# #   end
# # end




# # gem install selenium-webdriver -v "2.35.0"
