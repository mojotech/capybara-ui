module Dill
  # Use a List when you want to treat repeating elements as a unit.
  #
  # === Example
  #
  # Consider the following HTML:
  #
  #   <ul id="colors">
  #     <li>Red <span class="pt">Vermelho</span></li>
  #     <li>Green <span class="pt">Verde</span></li>
  #     <li>Blue <span class="pt">Azul</span></li>
  #   </ul>
  #
  # You can then define the following widget:
  #
  #   class Colors < Dill::List
  #     root '#colors'
  #   end
  #
  # Now you'll be able to iterate over each item:
  #
  #   # prints:
  #   # Red Vermelho
  #   # Green Verde
  #   # Blue Azul
  #   widget(:colors).each do |e|
  #     puts e
  #   end
  #
  # === Narrowing items
  #
  # You can define the root selector for your list items using the ::item macro:
  #
  #   class PortugueseColors < Dill::List
  #     root '#colors
  #     item '.pt'
  #   end
  #
  # If you iterate over this list you get the following:
  #
  #   # prints:
  #   # Vermelho
  #   # Verde
  #   # Azul
  #   widget(:portuguese_colors).each do |e|
  #     puts e
  #   end
  #
  # You can make a list out of any repeating elements, as long as you can define
  # parent and child selectors.
  #
  #   <div id="not-a-list-colors">
  #     <div class=".child">Red</div>
  #     <div class=".child">Green</div>
  #     <div class=".child">Blue</div>
  #   </div>
  #
  # You can define the following widget:
  #
  #   class NotAListColors < Dill::List
  #     root '#not-a-list-colors'
  #     item '.child'
  #   end
  class List < Widget
    DEFAULT_TYPE = Widget

    include Enumerable

    def_delegators :items, :size, :include?, :each, :empty?, :first, :last

    class << self
      # Configures the List item selector and class.
      #
      # === Using
      #
      # Given the following HTML:
      #
      #   <ul>
      #     <li>One</li>
      #     <li>Two</li>
      #     <li>Three</li>
      #   </ul>
      #
      # In its most basic form, allows you to configure the list item selector,
      # using the default list item class (Widget):
      #
      #   class Numbers < Dill::List
      #     root 'ul'
      #     item 'li'
      #   end
      #
      # You can define the list item class for the current List:
      #
      #   class Number < Dill::Widget
      #     # ...
      #   end
      #
      #   class Numbers < Dill::List
      #     root 'ul'
      #     item 'li', Number
      #   end
      #
      #   widget(:numbers).first.class < Number #=> true
      #
      # Alternatively, you can extend the list item type inline. This is useful
      # when you want to add small extensions to the default list item class.
      # The extensions will apply only to list items of the current List.
      #
      #   class Numbers < Dill::List
      #     root 'ul'
      #
      #     item 'li' do
      #       def upcase
      #         text.upcase
      #       end
      #     end
      #
      #     widget(:numbers).first.upcase #=> "ONE"
      #   end
      def item(selector, type = DEFAULT_TYPE, &block)
        klass = Class.new(type) { root selector }

        klass.class_eval(&block) if block_given?

        self.item_factory = klass
      end

      def item_factory
        @item_factory || DEFAULT_TYPE
      end

      attr_writer :item_factory
    end

    def to_table
      items.map { |e| Array(e) }
    end

    protected

    def_delegator 'self.class', :item_factory

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
