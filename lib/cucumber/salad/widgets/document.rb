module Cucumber
  module Salad
    module Widgets
      class Document < Widget
        root 'body'

        def initialize(options)
          @widget_lookup_scope = options.delete(:widget_lookup_scope) or
            raise "No scope given"

          super options
        end

        def widget(name)
          widget_class(name).new
        end

        private

        def widget_class(name)
          WidgetName.new(name).to_class(@widget_lookup_scope)
        end
      end
    end
  end
end
