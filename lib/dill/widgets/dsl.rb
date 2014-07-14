module Dill
  module Widgets
    module DSL
      # Declares a new child widget.
      #
      # Child widgets are accessible inside the container widget using the
      # {#widget} message, or by sending a message +name+. They
      # are automatically scoped to the parent widget's root node.
      #
      # @example Defining a widget
      #   # Given the following HTML:
      #   #
      #   # <div id="root">
      #   #   <span id="child">Child</span>
      #   # </div>
      #   class Container < Dill::Widget
      #     root '#root'
      #
      #     widget :my_widget, '#child'
      #   end
      #
      #   container = widget(:container)
      #
      #   # accessing using #widget
      #   my_widget = container.widget(:my_widget)
      #
      #   # accessing using #my_widget
      #   my_widget = container.my_widget
      #
      # @overload widget(name, selector, type = Widget)
      #
      #   The most common form, it allows you to pass in a selector as well as a
      #   type for the child widget. The selector will override +type+'s
      #   root selector, if +type+ has one defined.
      #
      #   @param name the child widget's name.
      #   @param selector the child widget's selector. You can pass either a
      #     String or, if you want to use a composite selector, an Array.
      #   @param type the child widget's parent class.
      #
      # @overload widget(name, type)
      #
      #   This form allows you to omit +selector+ from the arguments. It will
      #   reuse +type+'s root selector.
      #
      #   @param name the child widget's name.
      #   @param type the child widget's parent class.
      #
      #   @raise ArgumentError if +type+ has no root selector defined.
      #
      # @yield A block allowing you to further customize the widget behavior.
      #
      # @see #widget
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
