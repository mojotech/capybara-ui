require 'capybara/cuprite'
require 'webdrivers'

Capybara.default_max_wait_time = 2
Capybara.app = CapybaraUIApp
Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = Capybara.default_driver
