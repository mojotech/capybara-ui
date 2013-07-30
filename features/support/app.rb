require 'capybara/cucumber'
require 'sinatra/base'

class DillApp < Sinatra::Base; end

Capybara.app = DillApp

After do
  DillApp.reset!
end
