$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rails'
require 'capybara-ui'
require 'pry'
require 'rspec/given'
require 'sinatra/base'
require 'capybara/rspec'
require 'capybara/webkit'
require 'capybara/poltergeist'

Dir["./spec/support/**/*.rb"].each { |file| require file }

DRIVERS = [:webkit, :poltergeist]

class CapybaraUIApp < Sinatra::Base; end
Capybara.app = CapybaraUIApp

Capybara.javascript_driver = :webkit

module WidgetSpecDSL
  def GivenAction(body_html, path)
    before :each do
      CapybaraUIApp.class_eval do
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
  end

  def GivenHTML(body_html, path = '/test')
    GivenAction body_html, path

    Given(:path) { path }
    Given        { visit path }

    Given(:document) { CapybaraUI::Document.new(self.class) }
  end

  def GivenWidget
    let!(:_saved_constant_names) { Object.constants }

    before do
      yield
    end

    after do
      new_constants = Object.constants - _saved_constant_names

      new_constants.
        select { |e| Object.const_get(e) < CapybaraUI::Widget }.
        each { |e| Object.send :remove_const, e }
    end
  end
end

RSpec.configure do |config|
  config.extend WidgetSpecDSL

  config.include Capybara::DSL
  config.include CapybaraUI::DSL

  config.after :each do
    CapybaraUIApp.reset!
  end
end
