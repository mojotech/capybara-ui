require 'capybara/poltergeist'

Capybara.default_max_wait_time = 2
Capybara.app = DillApp
Capybara.javascript_driver = :poltergeist
