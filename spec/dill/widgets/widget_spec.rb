require 'spec_helper'

describe Dill::Widget do
  describe '.widget' do
    context "declaring a new widget with name and selector" do
      GivenHTML <<-HTML
        <span id="widget">Widget</span>
      HTML

      Given(:container_class) { WidgetMacroNameSelector }

      class WidgetMacroNameSelector < Dill::Widget
        widget :widget, '#widget'
      end

      context "accessing using #widget" do
        When(:widget) { container.widget(:widget) }

        Then { widget.is_a?(Dill::Widget) }
      end
    end

    context "declaring a new widget with name and type" do
      GivenHTML <<-HTML
        <span class="widget">Outer Widget</span>

        <div id="container">
          <span class="widget">Inner Widget</span>
        </div>
      HTML

      context "when type has valid selector" do
        Given(:container_class) { WidgetMacroNameTypeValid }

        class ChildWithSelector < Dill::Widget
          root '.widget'
        end

        When {
          class WidgetMacroNameTypeValid < Dill::Widget
            root '#container'

            widget :widget, ChildWithSelector
          end
        }

        When(:widget) { container.widget(:widget) }

        Then { widget.to_s == 'Inner Widget' }
      end

      context "when type has no selector" do
        class ChildWithoutSelector < Dill::Widget
        end

        When(:error) {
          class WidgetMacroNameTypeInvalid < Dill::Widget
            root '#container'

            widget :widget, ChildWithoutSelector
          end
        }

        Then { error == Failure(ArgumentError, /missing root selector/) }
      end
    end

    context "declaring a new widget with name, selector and type" do
      GivenHTML <<-HTML
        <span class="widget">Outer Widget</span>

        <div id="container">
          <span class="widget">Inner Widget</span>
        </div>
      HTML

      context "when child has a selector" do
        Given(:container_class) { WidgetMacroNameSelectorTypeSelector }

        class ChildWithOuterSelector < Dill::Widget
          root 'body > .widget'
        end

        When {
          class WidgetMacroNameSelectorTypeSelector < Dill::Widget
            root '#container'

            widget :widget, '.widget', ChildWithOuterSelector
          end
        }

        When(:widget) { container.widget(:widget) }

        Then { widget.to_s == 'Inner Widget' }
      end

      context "when type has no selector" do
        Given(:container_class) { WidgetMacroNameSelectorTypeNoSelector }

        class ChildNoSelector < Dill::Widget
        end

        When {
          class WidgetMacroNameSelectorTypeNoSelector < Dill::Widget
            root '#container'

            widget :widget, '.widget', ChildNoSelector
          end
        }

        When(:widget) { container.widget(:widget) }

        Then { widget.to_s == 'Inner Widget' }
      end
    end

    context "defining new behavior inline" do
      GivenHTML <<-HTML
        <span id="inline">Guybrush Threepwood</span>
      HTML

      Given(:container_class) { WidgetMacroInline }

      class WidgetMacroInline < Dill::Widget
        widget :inline, '#inline' do
          def inline!
            'yay'
          end
        end
      end

      context "using behavior defined inline" do
        When(:inline) { container.widget(:inline) }

        Then { inline.respond_to?(:inline!) == true }
      end
    end
  end

  describe "#has_widget?" do
    GivenHTML <<-HTML
      <span id="present">Guybrush Threepwood</span>
    HTML

    Given(:container_class) { HasWidget }

    class HasWidget < Dill::Widget
      widget :present, '#present'
      widget :absent, '#absent'
    end

    context "when widget exists" do
      Then { container.has_widget?(:present) }
    end

    context "when widget is missing" do
      Then { ! container.has_widget?(:absent) }
    end

    context "when widget is undefined" do
      When(:error) { container.has_widget?(:undefined) }

      Then { error == Failure(Dill::Missing, /`undefined' widget/) }
    end
  end

  describe "#has_action?" do
    GivenHTML <<-HTML
      <a href="#" id="present">Edit</a>
    HTML

    Given(:container_class) { HasAction }

    class HasAction < Dill::Widget
      action :present, '#present'
      action :absent, '#absent'
    end

    context "when action exists" do
      Then { container.has_action?(:present) }
    end

    context "when action is missing" do
      Then { ! container.has_action?(:absent) }
    end

    context "when the action is undefined" do
      When(:error) { container.has_action?(:undefined) }

      Then { error == Failure(Dill::Missing, /`undefined' action/) }
    end
  end

  describe "#reload" do
    context "when widget content changes", js: true do
      GivenHTML <<-HTML
        <script>
          function removeNode() {
            document.getElementById('remove').remove();
          }

          setInterval(removeNode, 500);
        </script>

        <span id="remove">Guybrush Threepwood</span>
      HTML

      Given(:container_class) { ReloadWithChange }

      class ReloadWithChange < Dill::Widget
        widget :removed, '#remove'
      end

      Then { ! container.reload.has_widget?(:removed) }
    end

    context "when widget remains the same", js: true do
      GivenHTML <<-HTML
        <span id="present">Guybrush Threepwood</span>
      HTML

      Given(:container_class) { ReloadWithNoChange }

      class ReloadWithNoChange < Dill::Widget
        widget :present, '#present'
      end

      Then { container.reload.has_widget?(:present) }
    end
  end
end
