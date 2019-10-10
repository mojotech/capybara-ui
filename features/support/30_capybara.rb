require 'capybara/cuprite'
require 'webdrivers'

Capybara.default_max_wait_time = 2
Capybara.app = CapybaraUIApp
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.current_driver = :selenium_chrome_headless
