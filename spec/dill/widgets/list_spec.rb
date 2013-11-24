require 'spec_helper'

describe Dill::List do
  describe 'wraps HTML' do
    context 'using defaults' do
      GivenHTML <<-HTML
        <ul>
          <li>One</li>
          <li>Two</li>
          <li>Three</li>
        </ul>
      HTML

      GivenWidget do
        class List < Dill::List
        end
      end

      When(:size) { widget(:list).size }
      When(:first) { widget(:list).first }

      Then { size == 3 }
      Then { first == 'One' }
    end

    context 'using custom selectors' do
      GivenHTML <<-HTML
        <div id="colors">
          <div class="color">Red</div>
          <div class="color">Green</div>
          <div class="color">Blue</div>
        </ul>
      HTML

      GivenWidget do
        class List < Dill::List
          root '#colors'

          item '.color'
        end
      end

      When(:size) { widget(:list).size }
      When(:first) { widget(:list).first }

      Then { size == 3 }
      Then { first == 'Red' }
    end
  end

  describe '#item' do
    context 'using the default item type' do
      Given(:default_item_type) { Dill::ListItem }

      GivenWidget do
        class List < Dill::List
          item '.selector' do
            def hurray!
              'hurray!'
            end
          end
        end
      end

      context 'interns the selector' do
        When(:selector) { List.item_factory.selector }

        Then { selector == ['.selector'] }
      end

      context 'uses the default item type as the superclass' do
        When(:type) { List.item_factory.superclass }

        Then { type == default_item_type }
      end

      context 'allows extending the list item type inline' do
        context 'adds the extensions to the list item type' do
          When(:methods) { List.item_factory.instance_methods(false) }

          Then { methods.include?(:hurray!) }
        end

        context 'does not touch the parent item type' do
          When(:methods) { default_item_type.instance_methods }

          Then { ! methods.include?(:hurray!) }
        end
      end
    end

    context 'allows setting a custom item type' do
      GivenWidget do
        class Child < Dill::Widget; end

        class List < Dill::List
          item '.selector', Child
        end
      end

      When(:base_type) { List.item_factory.superclass }

      Then { base_type == Child }
    end
  end

  describe '#empty?' do
    GivenWidget do
      class List < Dill::List
        root 'ul'
        item 'li'
      end
    end

    context 'when the list is empty' do
      GivenHTML <<-HTML
        <ul>
        </ul>
      HTML

      Then { widget(:list).empty? }
    end

    context 'when the list is not' do
      GivenHTML <<-HTML
        <ul>
          <li>Item<li>
        </ul>
      HTML

      Then { ! widget(:list).empty? }
    end
  end

  describe '#exclude?' do
    GivenWidget do
      class List < Dill::List
        root 'ul'
        item 'li'
      end
    end

    context 'when the element is on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Red</li>
        </ul>
      HTML

      Then { ! widget(:list).exclude?('Red') }
    end

    context 'when the element is not on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Yellow<li>
        </ul>
      HTML

      Then { widget(:list).exclude?('Red') }
    end
  end

  describe '#include?' do
    GivenWidget do
      class List < Dill::List
        root 'ul'
        item 'li'
      end
    end

    context 'when the element is on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Red</li>
        </ul>
      HTML

      Then { widget(:list).include?('Red') }
    end

    context 'when the element is not on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Yellow<li>
        </ul>
      HTML

      Then { ! widget(:list).include?('Red') }
    end
  end

  describe '#to_row' do
    GivenHTML <<-HTML
      <ul>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
      </ul>
    HTML

    GivenWidget do
      class List < Dill::List
      end
    end

    Then { widget(:list).to_row == %w(One Two Three) }
  end

  describe '#to_table' do
    GivenWidget do
      class List < Dill::List
      end
    end

    context 'with rows' do
      GivenHTML <<-HTML
        <ul>
          <li>One</li>
          <li>Two</li>
          <li>Three</li>
        </ul>
      HTML

      When(:table) { widget(:list).to_table }

      Then { table == [%w(One), %w(Two), %w(Three)] }
    end

    context 'without rows' do
      GivenHTML <<-HTML
        <ul></ul>
      HTML

      When(:table) { widget(:list).to_table }

      Then { table == [] }
    end
  end
end
