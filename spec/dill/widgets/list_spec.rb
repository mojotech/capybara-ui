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

      GivenWidget Dill::List

      When(:size) { w.size }
      When(:first) { w.first }

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

      GivenWidget Dill::List do
        root '#colors'

        item '.color'
      end

      When(:size) { w.size }
      When(:first) { w.first }

      Then { size == 3 }
      Then { first == 'Red' }
    end
  end

  describe '#item' do
    context 'using the default item type' do
      Given(:default_item_type) { Dill::ListItem }

      GivenWidget Dill::List do
        item '.selector'
      end

      context 'interns the selector' do
        When(:selector) { w_class.item_factory.selector }

        Then { selector == ['.selector'] }
      end

      context 'uses the default item type as the superclass' do
        When(:type) { w_class.item_factory.superclass }

        Then { type == default_item_type }
      end

      context 'allows extending the list item type inline' do
        GivenWidget Dill::List do
          item '.selector' do
            def hurray!
              'hurray!'
            end
          end
        end

        context 'adds the extensions to the list item type' do
          When(:methods) { w_class.item_factory.instance_methods(false) }

          Then { methods.include?(:hurray!) }
        end

        context 'does not touch the parent item type' do
          When(:methods) { default_item_type.instance_methods }

          Then { ! methods.include?(:hurray!) }
        end
      end
    end

    context 'allows setting a custom item type' do
      class Child < Dill::Widget; end

      GivenWidget Dill::List do
        item '.selector', Child
      end

      When(:base_type) { w_class.item_factory.superclass }

      Then { base_type == Child }
    end
  end

  describe '#empty?' do
    GivenWidget Dill::List do
      root 'ul'
      item 'li'
    end

    context 'when the list is empty' do
      GivenHTML <<-HTML
        <ul>
        </ul>
      HTML

      Then { w.empty? }
    end

    context 'when the list is not' do
      GivenHTML <<-HTML
        <ul>
          <li>Item<li>
        </ul>
      HTML

      Then { ! w.empty? }
    end
  end

  describe '#exclude?' do
    GivenWidget Dill::List do
      root 'ul'
      item 'li'
    end

    context 'when the element is on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Red</li>
        </ul>
      HTML

      Then { ! w.exclude?('Red') }
    end

    context 'when the element is not on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Yellow<li>
        </ul>
      HTML

      Then { w.exclude?('Red') }
    end
  end

  describe '#include?' do
    GivenWidget Dill::List do
      root 'ul'
      item 'li'
    end

    context 'when the element is on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Red</li>
        </ul>
      HTML

      Then { w.include?('Red') }
    end

    context 'when the element is not on the list' do
      GivenHTML <<-HTML
        <ul>
          <li>Yellow<li>
        </ul>
      HTML

      Then { ! w.include?('Red') }
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

    GivenWidget Dill::List

    Then { w.to_row == %w(One Two Three) }
  end

  describe '#to_table' do
    GivenWidget Dill::List

    context 'with rows' do
      GivenHTML <<-HTML
        <ul>
          <li>One</li>
          <li>Two</li>
          <li>Three</li>
        </ul>
      HTML

      When(:table) { w.to_table }

      Then { table == [%w(One), %w(Two), %w(Three)] }
    end

    context 'without rows' do
      GivenHTML <<-HTML
        <ul></ul>
      HTML

      When(:table) { w.to_table }

      Then { table == [] }
    end
  end
end