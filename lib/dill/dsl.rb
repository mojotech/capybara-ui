module Dill
  module DSL
    attr_writer :widget_lookup_scope

    # Clicks the widget defined by +name+ and optional +args+.
    #
    # Makes no distinction between links or buttons.
    #
    #   class MyWidget < Dill::Widget
    #     root { |text| ['.my-widget', text: text] }
    #   end
    #
    #   #  <a href="#one" class="my-widget">One</li>
    #   #  <a href="#two" class="my-widget">Two</li> <!-- clicks this node -->
    #   click :my_widget, 'Two'
    def click(name, *args)
      widget(name, *args).click
    end

    # @return [Document] the current document with the class of the
    #   current object set as the widget lookup scope.
    def document
      Document.new(widget_lookup_scope)
    end

    # @return [Boolean] Whether one or more widgets exist in the current
    #   document.
    def has_widget?(name, *args)
      document.has_widget?(name, *args)
    end

    def value(name, *args)
      widget(name, *args).value
    end

    def values(name, *args)
      widgets(name, *args).map(&:value)
    end

    # Returns a widget instance for the given name.
    #
    # @param name [String, Symbol]
    def widget(name, *args)
      document.widget(name, *args)
    end

    # Returns a list of widget instances for the given name.
    #
    # @param name [String, Symbol]
    def widgets(name, *args)
      document.widgets(name, *args)
    end

    def widget_lookup_scope
      @widget_lookup_scope ||= default_widget_lookup_scope
    end

    # re-run one or more assertions until either they all pass,
    # or Dill times out, which will result in a test failure.
    def eventually(wait_time = Capybara.default_wait_time, &block)
      Checkpoint.wait_for wait_time, &block
    end

    private

    def default_widget_lookup_scope
      Module === self ? self : self.class
    end
  end
end
