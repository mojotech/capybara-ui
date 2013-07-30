require 'chronic'
require 'nokogiri'
require 'capybara'

require 'dill/widget_container'
require 'dill/conversions'
require 'dill/instance_conversions'
require 'dill/node_text'
require 'dill/widget_name'
require 'dill/widgets'
require 'dill/table'
require 'dill/table/mapping'
require 'dill/table/void_mapping'
require 'dill/table/transformations'
require 'dill/table/cell_text'
require 'dill/widgets/document'
require 'dill/dsl'

module Dill
  # An exception that signals that something is missing.
  class Missing < StandardError; end
end
