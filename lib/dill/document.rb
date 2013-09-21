module Dill
  class Document
    include WidgetContainer

    def initialize(widget_lookup_scope)
      self.widget_lookup_scope = widget_lookup_scope or raise "No scope given"
    end

    def root
      Capybara.current_session
    end
  end
end
