# This file describes the organization of the major Widget API components.
#
# === Parts
#
# Widget parts encapsulate the set of behaviours that constitute a widget.
module Capybara
  module UI
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
end

module Capybara::UI::WidgetParts; end

require 'capybara-ui/widgets/parts/struct'
require 'capybara-ui/widgets/parts/container'

require 'capybara-ui/widgets/cucumber_methods'
require 'capybara-ui/widgets/dsl'
require 'capybara-ui/widgets/widget_class'
require 'capybara-ui/widgets/widget_name'
require 'capybara-ui/widgets/widget'
require 'capybara-ui/widgets/widget/node_filter'
require 'capybara-ui/widgets/list_item'
require 'capybara-ui/widgets/list'
require 'capybara-ui/widgets/field'
require 'capybara-ui/widgets/check_box'
require 'capybara-ui/widgets/radio_button'
require 'capybara-ui/widgets/select'
require 'capybara-ui/widgets/text_field'
require 'capybara-ui/widgets/field_group'
require 'capybara-ui/widgets/form'
require 'capybara-ui/widgets/document'
require 'capybara-ui/widgets/table'
require 'capybara-ui/widgets/string_value'
