module Dill
  module Widgets
    module DSL
      # Declares a new form widget.
      #
      # See features/role.feature.
      def form(name, *rest, &block)
        widget name, *rest, Dill::Form, &block
      end

      # Declares a new child widget.
      #
      # See https://github.com/mojotech/dill/blob/master/features/roles/widget.feature
      def widget(name, selector_or_parent, parent = Widget, &block)
        raise ArgumentError, "`#{name}' is a reserved name" \
          if WidgetParts::Container.instance_methods.include?(name.to_sym)

        case selector_or_parent
        when String, Array, Proc
          selector, type = selector_or_parent, parent
        when Class
          selector, type = selector_or_parent.selector, selector_or_parent
        else
          raise ArgumentError, "wrong number of arguments (#{rest.size} for 1)"
        end

        raise TypeError, "can't convert `#{type}' to Widget" \
          unless type.methods.include?(:selector)

        raise ArgumentError, "missing selector" unless selector || type.selector

        child = WidgetClass.new(selector, type, &block)

        const_set(Dill::WidgetName.new(name).to_sym, child)

        child
      end
    end
  end
end
