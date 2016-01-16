module CapybaraUI
  module WidgetParts
    module Struct
      def self.included(target)
        target.extend ClassMethods
      end

      module ClassMethods
        def attribute(name, selector, &block)
          child = widget(name, selector, &block)

          class_eval <<-WIDGET
            def #{name}
              widget(:#{name}).value
            end
          WIDGET

          child
        end

        def boolean(name, selector, &block)
          child = widget(name, selector, &block)

          class_eval <<-WIDGET
            def #{name}?
              widget(:#{name}).value
            end
          WIDGET

          child.class_eval <<-VALUE
            def value
              CapybaraUI::Conversions::Boolean(text)
            end
          VALUE

          child
        end

        def date(name, selector, &block)
          child = attribute(name, selector, &block)

          child.class_eval <<-VALUE
            def value
              Date.parse(text)
            end
          VALUE

          child
        end

        def float(name, selector, &block)
          child = attribute(name, selector, &block)

          child.class_eval <<-VALUE
            def value
              Float(text)
            end
          VALUE

          child
        end

        def integer(name, selector, &block)
          child = attribute(name, selector, &block)

          child.class_eval <<-VALUE
            def value
              Integer(text)
            end
          VALUE

          child
        end

        def list(name, selector, options = {}, &block)
          child = widget(name, selector, CapybaraUI::List) do
            item options[:item_selector], options[:item_class] || ListItem
          end

          class_eval <<-WIDGET
            def #{name}
              widget(:#{name}).value
            end
          WIDGET

          child.class_eval(&block) if block_given?

          child
        end

        def string(name, *args, &block)
          child = attribute(name, *args, &block)

          child.class_eval <<-VALUE
            def value
              text
            end
          VALUE

          child
        end

        def time(name, *args, &block)
          child = attribute(name, *args, &block)

          child.class_eval <<-VALUE
            def value
              Time.parse(text)
            end
          VALUE

          child
        end
      end
    end
  end
end
