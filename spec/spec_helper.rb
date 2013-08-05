$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'dill'
require 'rspec/given'
require 'sinatra/base'
require 'capybara/rspec'
require 'capybara/webkit'
require 'capybara/poltergeist'

class DillApp < Sinatra::Base; end
Capybara.app = DillApp

Capybara.javascript_driver = :webkit

module WidgetSpecDSL
  def GivenHTML(body_html, path = "/test")
    before :all do
      DillApp.class_eval do
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

    Given(:container_class) { Container }
    Given(:container_root)  { find(container_class.selector || 'body') }
    Given(:container)       { container_class.new(root: container_root) }

    Given(:path)            { path }
    Given                   { visit path }

    after :all do
      DillApp.reset!
    end
  end
end

RSpec.configure do |config|
  config.extend WidgetSpecDSL

  config.include Capybara::DSL
  config.include Dill::DSL
end
