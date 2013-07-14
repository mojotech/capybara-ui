module Cucumber
  module Salad
    module Widgets
      class Document < Widget
        include WidgetContainer

        root 'body'

        def initialize(options)
          self.widget_lookup_scope =
            options.delete(:widget_lookup_scope) or raise "No scope given"

          super options
        end

        def widget(name)
          widget_class(name).new
        end
      end
    end
  end
end
