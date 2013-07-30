module Dill
  module DSL
    attr_writer :widget_lookup_scope

    # @return [Widgets::Document] the current document with the class of the
    #   current object set as the widget lookup scope.
    def document
      Widgets::Document.new(widget_lookup_scope: widget_lookup_scope)
    end

    # @return [Boolean] Whether one or more widgets exist in the current
    #   document.
    def has_widget?(name)
      document.has_widget?(name)
    end

    # Returns a widget instance for the given name.
    #
    # @param name [String, Symbol]
    def widget(name, options = {})
      document.widget(name, options)
    end

    def widget_lookup_scope
      @widget_lookup_scope ||= default_widget_lookup_scope
    end

    private

    def default_widget_lookup_scope
      Module === self ? self : self.class
    end
  end
end
