require 'capybara/cuprite'

Capybara.default_max_wait_time = 2
Capybara.app = CapybaraUIApp
Capybara.javascript_driver = :selenium_chrome
Capybara.current_driver = :selenium_chrome
