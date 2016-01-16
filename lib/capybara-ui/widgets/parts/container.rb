module CapybaraUI
  module WidgetParts
    module Container
      include CapybaraUI

      def has_widget?(name, *args)
        deprecate('has_widget? and its alias widget?', 'visible?')
        widget_class(name).present_in?(self, *args)
      end

      alias_method :widget?, :has_widget?

      def visible?(name, *args)
        widget_class(name).present_in?(self, *args)
      end

      def not_visible?(name, *args)
        widget_class(name).not_present_in?(self, *args)
      end

      def widget(name, *args)
        first, rest = [*name, *args]

        widget_class(first).find_in(self, *rest)
      end

      def widgets(name, *args)
        first, rest = [*name, *args]

        widget_class(first).find_all_in(self, *rest)
      end

      private

      attr_writer :widget_lookup_scope

      def widget_class(name)
        WidgetName.new(name).to_class(widget_lookup_scope)
      end

      def widget_lookup_scope
        @widget_lookup_scope || self.class
      end
    end
  end
end
