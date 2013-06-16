require 'capybara/cucumber'
require 'sinatra/base'

class SaladApp < Sinatra::Base
  get '/entries/new' do
    "Nice!"
  end
end

Capybara.app = SaladApp
