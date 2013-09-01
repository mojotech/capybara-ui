$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))

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

  def GivenHTML(body_html, path = "/test")
    GivenAction body_html, path

    Given(:path) { path }
    Given        { visit path }
  end

  def GivenWidget(parent_class = Dill::Widget, name = :w, &block)
    klass = :"#{name}_class"
    root  = :"#{name}_root"

    Given(name)  { send(klass).new(send(root)) }
    Given(klass) { Class.new(parent_class, &block) }
    Given(root)  { find(*send(klass).selector || 'body') }
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
