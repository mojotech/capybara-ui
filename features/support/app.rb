require 'capybara/cucumber'
require 'sinatra/base'

class SaladApp < Sinatra::Base
end

Capybara.app = SaladApp
