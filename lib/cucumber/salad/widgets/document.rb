module Cucumber
  module Salad
    module Widgets
      class Document
        include WidgetContainer

        def initialize(options)
          self.widget_lookup_scope =
            options.delete(:widget_lookup_scope) or raise "No scope given"
        end

        def root
          Capybara.current_session
        end
      end
    end
  end
end
