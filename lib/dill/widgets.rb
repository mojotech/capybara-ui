# This file describes the organization of the major Widget API components.
#
# === Parts
#
# Widget parts encapsulate the set of behaviours that constitute a widget.
module Dill
  module Constructors
    def Widget(*selector, &block)
      if block_given?
        WidgetClass.new(selector.flatten) do
          define_method :value do
            block.call(text)
          end
        end
      else
        WidgetClass.new(selector.flatten)
      end
    end

    alias_method :String, :Widget

    def Integer(*selector)
      Widget(selector) { |text| Kernel::Integer(text) }
    end

    require 'bigdecimal'

    def Decimal(*selector)
      Widget(selector) { |text|
        # ensure we can convert to float first
        Float(text) && BigDecimal.new(text)
      }
    end
  end

  extend Constructors
end

module Dill::WidgetParts; end

require 'dill/widgets/parts/struct'
require 'dill/widgets/parts/container'

require 'dill/widgets/cucumber_methods'
require 'dill/widgets/dsl'
require 'dill/widgets/widget_class'
require 'dill/widgets/widget_name'
require 'dill/widgets/widget'
require 'dill/widgets/widget/node_filter'
require 'dill/widgets/list_item'
require 'dill/widgets/list'
require 'dill/widgets/field'
require 'dill/widgets/check_box'
require 'dill/widgets/select'
require 'dill/widgets/text_field'
require 'dill/widgets/field_group'
require 'dill/widgets/form'
require 'dill/widgets/document'
require 'dill/widgets/table'
require 'dill/widgets/string_value'
require 'dill/widgets/array_value'
require 'dill/widgets/hash_value'
