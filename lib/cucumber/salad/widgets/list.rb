module Cucumber
  module Salad
    module Widgets
      class List < Widget
        DEFAULT_TYPE = Atom

        include Enumerable

        def_delegators :items, :size, :include?, :each, :empty?, :first, :last

        def self.item(selector, type = DEFAULT_TYPE, &item_for)
          define_method :item_selector do
            @item_selector ||= selector
          end

          if block_given?
            define_method :item_for, &item_for
          else
            define_method :item_factory do
              type
            end
          end
        end

        def to_table
          items.map { |e| Array(e) }
        end

        protected

        attr_writer :item_selector

        def item_factory
          DEFAULT_TYPE
        end

        def item_for(node)
          item_factory.new(root: node)
        end

        def item_selector
          'li'
        end

        def items
          root.all(item_selector).map { |node| item_for(node) }
        end
      end
    end
  end
end
