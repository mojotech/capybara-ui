$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'dill'
require 'rspec/given'
require 'sinatra/base'
require 'capybara/rspec'
require 'capybara/webkit'
require 'capybara/poltergeist'

DRIVERS = [:webkit, :poltergeist]

class DillApp < Sinatra::Base; end
Capybara.app = DillApp

Capybara.javascript_driver = :webkit

module WidgetSpecDSL
  def GivenAction(body_html, path)
    before :each do
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
  end

  def GivenHTML(body_html, path = '/test')
    GivenAction body_html, path

    Given(:path) { path }
    Given        { visit path }

    Given(:document) { Dill::Document.new(self.class) }
  end

  def GivenWidget
    let!(:_saved_constant_names) { Object.constants }

    before do
      yield
    end

    after do
      new_constants = Object.constants - _saved_constant_names

      new_constants.
        select { |e| Object.const_get(e) < Dill::Widget }.
        each { |e| Object.send :remove_const, e }
    end
  end
end

RSpec.configure do |config|
  config.extend WidgetSpecDSL

  config.include Capybara::DSL
  config.include Dill::DSL

  config.after :each do
    DillApp.reset!
  end
end
