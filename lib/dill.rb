require 'chronic'
require 'nokogiri'
require 'capybara'

require 'dill/conversions'
require 'dill/instance_conversions'
require 'dill/checkpoint'
require 'dill/widgets'
require 'dill/text_table'
require 'dill/text_table/mapping'
require 'dill/text_table/void_mapping'
require 'dill/text_table/transformations'
require 'dill/text_table/cell_text'
require 'dill/capybara'
require 'dill/dsl'

module Dill
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
