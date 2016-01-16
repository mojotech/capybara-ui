module CapybaraUI
  # Use a List when you want to treat repeating elements as a unit.
  #
  # === Usage
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
  #   class Colors < CapybaraUI::List
  #     root '#colors'
  #     item 'li'
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
  # This is the same as doing the following in Capybara:
  #
  #   all('#colors li').each do |e|
  #     puts e.text.strip
  #   end
  #
  # Note that, by default, the root selector of a List is +ul+ and the list
  # item selector is +li+. So you could wrap the +<ul>+ above simply by using
  # the following:
  #
  #   class Colors < CapybaraUI::List
  #   end
  #
  # ==== Narrowing items
  #
  # You can define the root selector for your list items using the ::item macro:
  #
  #   class PortugueseColors < CapybaraUI::List
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
  #     <div class="child">Red</div>
  #     <div class="child">Green</div>
  #     <div class="child">Blue</div>
  #   </div>
  #
  # You can define the following widget:
  #
  #   class NotAListColors < CapybaraUI::List
  #     root '#not-a-list-colors'
  #     item '.child'
  #   end
  class List < Widget
    include Enumerable

    def_delegators :items, :each, :first, :last

    root 'ul' unless filter?

    class << self
      # Configures the List item selector and class.
      #
      # === Usage
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
      # using the default list item class (CapybaraUI::ListItem):
      #
      #   class Numbers < CapybaraUI::List
      #     root 'ul'
      #     item 'li'
      #   end
      #
      # ==== Extending the list item class
      #
      # You can define the list item class for the current List:
      #
      #   class Number < CapybaraUI::Widget
      #     # ...
      #   end
      #
      #   class Numbers < CapybaraUI::List
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
      #   class Numbers < CapybaraUI::List
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
      def item(selector, type = ListItem, &block)
        self.item_factory = WidgetClass.new(selector, type, &block)
      end

      attr_writer :item_factory

      def item_factory
        @item_factory ||= WidgetClass.new('li', ListItem)
      end
    end

    def count
      items.count
    end

    # TODO: Convert value to primitive data structures.
    def empty?
      items.empty?
    end

    def exclude?(element)
      ! include?(element)
    end

    def include?(element)
      value.include?(element)
    end

    def length
      items.length
    end

    def size
      items.size
    end

    def to_row
      items.map(&:to_cell)
    end

    def to_table
      items.map(&:to_row)
    end

    def value
      items.map(&:value)
    end

    protected

    def_delegator 'self.class', :item_factory

    def item_for(node)
      item_factory.new(node)
    end

    def item_filter
      item_factory.filter
    end

    def items
      item_filter.nodes(self).map { |node| item_for(node) }
    end
  end
end
