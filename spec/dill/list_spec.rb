require 'spec_helper'

describe Dill::List do
  describe "#item" do
    context "using the default item type" do
      GivenWidget Dill::List do
        item '.selector'
      end

      context "interns the selector" do
        When(:selector) { w_class.item_factory.selector }

        Then { selector == '.selector' }
      end

      context "uses the default item type as the superclass" do
        When(:base_type) { w_class.item_factory.superclass }

        Then { base_type == Dill::List::DEFAULT_TYPE }
      end

      context "allows extending the list item type inline" do
        GivenWidget Dill::List do
          item '.selector' do
            def hurray!
              'hurray!'
            end
          end
        end

        context "adds the extensions to the list item type" do
          When(:methods) { w_class.item_factory.instance_methods(false) }

          Then { methods.include?(:hurray!) }
        end

        context "does not touch the parent item type" do
          When(:methods) { Dill::List::DEFAULT_TYPE.instance_methods }

          Then { ! methods.include?(:hurray!) }
        end
      end
    end

    context "allows setting a custom item type" do
      class Child < Dill::Widget; end

      GivenWidget Dill::List do
        item '.selector', Child
      end

      When(:base_type) { w_class.item_factory.superclass }

      Then { base_type == Child }
    end
  end

  describe ".empty?" do
    GivenWidget Dill::List do
      root 'ul'
      item 'li'
    end

    context "when the list is empty" do
      GivenHTML <<-HTML
        <ul>
        </ul>
      HTML

      Then { w.empty? == true }
    end

    context "when the list is not" do
      GivenHTML <<-HTML
        <ul>
          <li>Item<li>
        </ul>
      HTML

      Then { w.empty? == false }
    end
  end
end
