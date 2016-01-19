module Capybara
  module UI
    module WidgetClass
      def self.new(selector, parent = Widget, &extensions)
        klass = Class.new(parent) { root selector }

        klass.class_eval(&extensions) if block_given?

        klass
      end
    end
  end
end
