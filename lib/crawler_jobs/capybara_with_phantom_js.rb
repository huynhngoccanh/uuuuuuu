# require 'capybara'
# require 'capybara/poltergeist'
# module CapybaraWithPhantomJs
#   include Capybara::DSL
  
#   # Create a new PhantomJS session in Capybara
#   def new_session
#     options = {  window_size: [1280, 600], js_errors: false, timeout: 5000, 
#       #phantomjs_logger: Logger.new(STDOUT),
#       logger: nil,        
#       phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }
#     # Register PhantomJS (aka poltergeist) as the driver to use
    
    
#     Capybara.configure do |c|
#      c.javascript_driver = :poltergeist
#      #c.javascript_driver = :webkit
#      c.default_driver = :poltergeist
#      #c.default_driver = :webkit
#      #c.app_host = "http://localhost:3000"
#     end
    
#     Capybara.register_driver :poltergeist do |app|
#       Capybara::Poltergeist::Driver.new(app, options)
#     end

# #    Capybara.register_driver :selenium do |app|
# #      Capybara::Selenium::Driver.new(app, :browser => :chrome)
# #    end    
    
#     #Capybara.run_server = false

    
     
    
#     # Use XPath as the default selector for the find method
#     Capybara.default_selector = :css

#     # Start up a new thread
#     @session = Capybara::Session.new(:poltergeist)

#     # Report using a particular user agent
#     @session.driver.headers = { 'User-Agent' => "Mozilla/5.0 (Macintosh; Intel Mac OS X)" }
#   # @session.driver.headers = { "User-Agent" => "Poltergeist" }
#     # Return the driver's session
#     @session
#   end

#   # Returns the current session's page
#   def html
#     session.html
#   end
# end