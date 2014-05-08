module Dill
  module WidgetParts
    module Container
      def has_no_widget?(name)
        widget(name).absent?
      end

      def has_widget?(name, *args)
        widget(name, *args).present?
      end

      alias_method :widget?, :has_widget?

      def widget(name, *args)
        widget_class(name).find_in(self, *args)
      end

      def widgets(name, *args)
        widget_class(name).find_all_in(self, *args)
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
