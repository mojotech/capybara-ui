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
      def widget(name, *rest, &block)
        raise ArgumentError, "`#{name}' is a reserved name" \
          if WidgetParts::Container.instance_methods.include?(name.to_sym)

        case rest.first
        when Class
          arg_count = rest.size + 1
          raise ArgumentError, "wrong number of arguments (#{arg_count} for 2)" \
            unless arg_count == 2

          type = rest.first
          raise TypeError, "can't convert `#{type}' to Widget" \
            unless type.methods.include?(:selector)
          raise ArgumentError, "missing root selector for `#{type}'" \
            unless type.selector

          selector = type.selector
        when String, Array, Proc
          arg_count = rest.size + 1

          case arg_count
          when 0, 1
            raise ArgumentError, "wrong number of arguments (#{arg_count} for 2)"
          when 2
            selector, type = [*rest, Widget]
          when 3
            selector, type = rest

            raise TypeError, "can't convert `#{type}' to Widget" \
              unless Class === type
          else
            raise ArgumentError, "wrong number of arguments (#{arg_count} for 3)"
          end
        else
          raise ArgumentError, "unknown method signature: #{rest.inspect}"
        end

        child = WidgetClass.new(selector, type, &block)

        const_set(Dill::WidgetName.new(name).to_sym, child)

        child
      end
    end
  end
end
