require 'chronic'
require 'nokogiri'
require 'capybara'

require 'dill/checkpoint'
require 'dill/widget_checkpoint'
require 'dill/widget_container'
require 'dill/conversions'
require 'dill/instance_conversions'
require 'dill/node_text'
require 'dill/widget_name'
require 'dill/widget'
require 'dill/list_item'
require 'dill/list'
require 'dill/base_table'
require 'dill/auto_table'
require 'dill/table'
require 'dill/field_group'
require 'dill/form'
require 'dill/document'
require 'dill/text_table'
require 'dill/text_table/mapping'
require 'dill/text_table/void_mapping'
require 'dill/text_table/transformations'
require 'dill/text_table/cell_text'
require 'dill/dsl'

module Dill
  # An exception that signals that something is missing.
  class Missing < StandardError; end
end
