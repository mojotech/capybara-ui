module Capybara
  module UI
    class Widget
      class NodeFilter
        attr_reader :selector

        def initialize(*selector)
          @selector = selector.flatten
        end

        def node(parent_widget, *args)
          a, kw = capybara_selector(*args)
          parent_widget.root.find(*a, **kw)
        end

        def node?(parent_widget, *args)
          a, kw = capybara_selector(*args)
          parent_widget.root.has_selector?(*a, **kw)
        end

        def nodeless?(parent_widget, *args)
          a, kw = capybara_selector(*args)
          parent_widget.root.has_no_selector?(*a, **kw)
        end

        def nodes(parent_widget, *args)
          a, kw = capybara_selector(*args)
          parent_widget.root.all(*a, **kw)
        end

        private

        def capybara_selector(*args)
          # TODO detect signature errors (e.g., passing a different arity than the
          # one required by the selector proc, etc)
          selector = if @selector.first.respond_to?(:call)
                       @selector.first.call(*args)
                     else
                       @selector
                     end
          selector = Array(selector).flatten

          defaults = {:wait => 0}

          if Hash === selector.last
            return selector, defaults.merge(selector.pop)
          else
            return selector, defaults
          end
        end
      end
    end
  end
end
