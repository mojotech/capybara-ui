require 'rails'
require 'action_controller/railtie'
require 'pry'

class CapybaraUIApp < Rails::Application
  config.root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  secret = '39a988a1711e621dbc7718d4c89f5e3f'
  config.session_store :cookie_store, :key => secret
  config.secret_key_base = secret

  config.action_controller.perform_caching = false

  log_file = File.new(File.join(config.root, 'log', 'test.log'), 'w+')
  config.logger = Logger.new(log_file)
  Rails.logger = config.logger
end

ActionDispatch.test_app = CapybaraUIApp

class TestController < ActionController::Base
  before_action :debug

  def debug
    binding.pry
  end
end

module WebApp
  def define_page_body(html, path = "/test")
    define_page <<-HTML, path
      <html>
      <body>
        #{html}
      </body>
      </html>
    HTML
  end

  def define_page(html, path = "/test")
    name = path.gsub('/', '_')[1 .. -1]

    TestController.class_eval do
      # binding.pry
      define_method name do
        render html: html
      end
    end

    CapybaraUIApp.routes.draw do
      get path, to: "test##{name}", as: name
    end
  end
end

World WebApp
