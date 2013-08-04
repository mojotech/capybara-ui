require 'spec_helper'

describe Dill::Widget do
  describe '.widget' do
    context "declaring a new widget with name and selector" do
      GivenHTML <<-HTML
        <span id="widget">Widget</span>
      HTML

      Given(:container_class) { WidgetMacro }

      class WidgetMacro < Dill::Widget
        widget :widget, '#widget'
      end

      context "accessing using #widget" do
        When(:widget) { container.widget(:widget) }

        Then { widget.is_a?(Dill::Widget) }
      end
    end

    context "defining new behavior inline" do
      GivenHTML <<-HTML
        <span id="inline">Guybrush Threepwood</span>
      HTML

      Given(:container_class) { WidgetMacro }

      class WidgetMacro < Dill::Widget
        widget :inline, '#inline' do
          def inline!
            'yay'
          end
        end
      end

      context "accessing using #widget" do
        When(:inline) { container.widget(:inline) }

        Then { inline.respond_to?(:inline!) == true }
      end
    end
  end

  describe "#has_widget?" do
    GivenHTML <<-HTML
      <span id="present">Guybrush Threepwood</span>
    HTML

    class Container < Dill::Widget
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

    class Container < Dill::Widget
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

      class Container < Dill::Widget
        widget :removed, '#remove'
      end

      Then { ! container.reload.has_widget?(:removed) }
    end

    context "when widget remains the same", js: true do
      GivenHTML <<-HTML
        <span id="present">Guybrush Threepwood</span>
      HTML

      class Container < Dill::Widget
        widget :present, '#present'
      end

      Then { container.reload.has_widget?(:present) }
    end
  end
end
