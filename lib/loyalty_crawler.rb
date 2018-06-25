require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

module LoyaltyCrawler
	include Capybara::DSL
	Capybara.default_selector = :css
	Capybara.current_driver = :selenium
	Capybara.current_driver = :poltergeist
	Capybara.default_max_wait_time = 10

	options = {  window_size: [1280, 600], js_errors: false, timeout: 180, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'] }

	Capybara.register_driver(:poltergeist) do |app|
	  Capybara::Poltergeist::Driver.new(app, options)
	end

	Capybara.register_driver :selenium do |app|
  	Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

	Capybara.configure do |c|
	  c.javascript_driver = :webkit
	  c.default_driver = :webkit
	  c.javascript_driver = :poltergeist
	  c.default_driver = :poltergeist
	  c.app_host = "http://localhost:3000"
	end
end
