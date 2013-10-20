module Dill
  module WidgetParts
    module Struct
      def self.included(target)
        target.extend ClassMethods
      end

      module ClassMethods
        def attribute(name, *args, &block)
          child = widget(name, *args, &block)

          class_eval <<-WIDGET
            def #{name}
              widget(:#{name}).dynamic_value
            end
          WIDGET

          child
        end

        def boolean(name, *args, &block)
          child = widget(name, *args, &block)

          class_eval <<-WIDGET
            def #{name}?
              delay { widget(:#{name}).value }
            end
          WIDGET

          child.class_eval <<-VALUE
            def value
              Dill::Conversions::Boolean(text)
            end
          VALUE

          child
        end

        def date(name, *args, &block)
          child = attribute(name, *args, &block)

          child.class_eval <<-VALUE
            def value
              Date.parse(text)
            end
          VALUE

          child
        end

        def float(name, *args, &block)
          child = attribute(name, *args, &block)

          child.class_eval <<-VALUE
            def value
              Float(text)
            end
          VALUE

          child
        end

        def integer(name, *args, &block)
          child = attribute(name, *args, &block)

          child.class_eval <<-VALUE
            def value
              Integer(text)
            end
          VALUE

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
