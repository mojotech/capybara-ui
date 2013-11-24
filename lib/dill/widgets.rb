# This file describes the organization of the major Widget API components.
#
# === Parts
#
# Widget parts encapsulate the set of behaviours that constitute a widget.
module Dill
  module Constructors
    def Widget(selector)
      WidgetClass.new(selector)
    end

    alias_method :String, :Widget

    def Integer(selector)
      WidgetClass.new(selector) do
        def value
          Integer(text)
        end
      end
    end
  end

  extend Constructors
end

module Dill::WidgetParts; end

require 'dill/widgets/parts/struct'
require 'dill/widgets/parts/container'

require 'dill/widgets/widget_class'
require 'dill/widgets/widget_checkpoint'
require 'dill/widgets/widget_name'
require 'dill/widgets/widget'
require 'dill/widgets/list_item'
require 'dill/widgets/list'
require 'dill/widgets/base_table'
require 'dill/widgets/auto_table'
require 'dill/widgets/table'
require 'dill/widgets/field'
require 'dill/widgets/check_box'
require 'dill/widgets/select'
require 'dill/widgets/text_field'
require 'dill/widgets/field_group'
require 'dill/widgets/form'
require 'dill/widgets/document'
