require 'chronic'
require 'nokogiri'
require 'capybara'

require 'dill/conversions'
require 'dill/instance_conversions'
require 'dill/checkpoint'
require 'dill/dynamic_value'
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
end
