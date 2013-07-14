module Cucumber
  module Salad
    module DSL
      attr_writer :widget_lookup_scope

      # @return [Widgets::Document] the current document with the class of the
      #   current object set as the widget lookup scope.
      def document
        Widgets::Document.new(widget_lookup_scope: widget_lookup_scope)
      end

      # Returns a widget instance for the given name.
      #
      # @param name [String, Symbol]
      def widget(name)
        document.widget(name)
      end

      def widget_lookup_scope
        @widget_lookup_scope || self.class
      end
    end
  end
end
