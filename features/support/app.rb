require 'capybara/cucumber'
require 'sinatra/base'

class DillApp < Sinatra::Base; end

After do
  DillApp.reset!
end
