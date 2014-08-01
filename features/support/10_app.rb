require 'capybara/cucumber'
require 'rails'
require 'action_controller/railtie'

class DillApp < Rails::Application
  config.root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))

  secret = '39a988a1711e621dbc7718d4c89f5e3f'
  config.session_store :cookie_store, :key => secret
  config.secret_token = secret
  config.secret_key_base = secret

  log_file = File.new(File.join(config.root, 'log', 'test.log'), 'w+')
  config.logger = Logger.new(log_file)
  Rails.logger = config.logger
end

ActionDispatch.test_app = DillApp

class TestController < ActionController::Base
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
      define_method name do
        render :text => html
      end
    end

    DillApp.routes.draw do
      get path => "test##{name}", :as => name
    end
  end
end

World WebApp
