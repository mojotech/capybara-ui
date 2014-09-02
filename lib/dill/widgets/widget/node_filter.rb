module Dill
  class Widget
    class NodeFilter
      attr_reader :selector

      def initialize(*selector)
        @selector = selector.flatten
      end

      def node(parent_widget, *args)
        parent_widget.root.find(*capybara_selector(*args))
      end

      def nodes(parent_widget, *args)
        parent_widget.root.all(*capybara_selector(*args))
      end

      private

      def capybara_selector(*args)
        # TODO detect signature errors (e.g., passing a different arity than the
        # one required by the selector proc, etc)
        if @selector.first.respond_to?(:call)
          @selector.first.call(*args)
        else
          @selector
        end
      end
    end
  end
end
