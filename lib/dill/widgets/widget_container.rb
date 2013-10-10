module Dill
  module WidgetContainer
    def has_widget?(name)
      widget(name).present?
    end

    def widget(name)
      widget_class(name).find_in(self)
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
