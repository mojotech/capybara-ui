require 'chronic'
require 'nokogiri'
require 'capybara'

require 'capybara-ui/optional_dependencies'
require 'capybara-ui/conversions'
require 'capybara-ui/instance_conversions'
require 'capybara-ui/checkpoint'
require 'capybara-ui/widgets'
require 'capybara-ui/text_table'
require 'capybara-ui/text_table/mapping'
require 'capybara-ui/text_table/void_mapping'
require 'capybara-ui/text_table/transformations'
require 'capybara-ui/text_table/cell_text'
require 'capybara-ui/capybara'
require 'capybara-ui/dsl'

module CapybaraUI
  # An exception that signals that something is missing.
  class Missing < StandardError; end
  class MissingWidget < StandardError; end
  class AmbiguousWidget < StandardError; end
  class InvalidOption < StandardError; end
  class InvalidRadioButton < StandardError; end

  def deprecate(method, alternate_method, once=false)
    @deprecation_notified ||= {}
    warn "DEPRECATED: ##{method} is deprecated, please use ##{alternate_method} instead" unless once and @deprecation_notified[method]
    @deprecation_notified[method] = true
  end
end
