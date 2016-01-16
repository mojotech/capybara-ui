require 'capybara/poltergeist'

Capybara.default_max_wait_time = 2
Capybara.app = CapybaraUIApp
Capybara.javascript_driver = :poltergeist
