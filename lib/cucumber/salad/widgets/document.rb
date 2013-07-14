module Cucumber
  module Salad
    module Widgets
      class Document < Widget
        include WidgetContainer

        root 'body'

        def initialize(options)
          self.widget_lookup_scope =
            options.delete(:widget_lookup_scope) or raise "No scope given"

          options[:root] ||= Capybara.current_session

          super options
        end

        def widget(name)
          widget_class(name).in_node(root)
        end
      end
    end
  end
end
