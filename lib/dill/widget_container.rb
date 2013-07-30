module Dill
  module WidgetContainer
    def has_widget?(name)
      widget_class(name).present_in?(root)
    end

    def widget(name, options = {})
      widget_class(name).find_in(root, options)
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
