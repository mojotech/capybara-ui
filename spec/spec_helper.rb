$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'cucumber/salad'
require 'rspec/given'
require 'sinatra/base'
require 'capybara'

class SaladApp < Sinatra::Base; end
Capybara.app = SaladApp

module WidgetSpecDSL
  def GivenHTML(body_html, path = "/test")
    before :all do
      SaladApp.class_eval do
        get path do
          <<-HTML
          <html>
          <body>
            #{body_html}
          </body>
          </html>
          HTML
        end
      end
    end

    Given(:container_root) { find('body') }
    Given(:container)      { Container.new(root: container_root) }

    Given(:path)           { path }
    Given                  { visit path }

    after :all do
      SaladApp.reset!
    end
  end
end

RSpec.configure do |config|
  config.extend WidgetSpecDSL

  config.include Capybara::DSL
  config.include Cucumber::Salad::DSL
end
