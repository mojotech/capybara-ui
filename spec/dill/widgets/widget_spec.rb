require 'spec_helper'

DRIVERS.each do |driver|
  describe Dill::Widget, "using #{driver}", js: true, driver: driver do
    describe '.widget' do
      context "declaring a new widget with name and selector" do
        GivenHTML <<-HTML
          <span id="widget">Widget</span>
        HTML

        GivenWidget { widget :the_widget, '#widget' }

        context "accessing using #widget" do
          When(:widget) { w.widget(:the_widget) }

          Then { widget.is_a?(Dill::Widget) }
        end

        context "accessing using #<name>" do
          When(:widget) { w.the_widget }

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

        GivenWidget(Dill::Widget, :parent) { root '#container' }

        context "when child type has valid selector" do
          GivenWidget(Dill::Widget, :child) { root '.widget' }

          Given { parent_class.widget :the_widget, child_class }

          When(:widget) { parent.widget(:the_widget) }

          Then { widget.to_s == 'Inner Widget' }
        end

        context "when type has no selector" do
          GivenWidget Dill::Widget, :child

          When(:result) { parent_class.widget :the_widget, child_class }

          Then { result == Failure(ArgumentError, /missing root selector/) }
        end
      end

      context "declaring a new widget with name, selector and type" do
        GivenHTML <<-HTML
          <span class="widget">Outer Widget</span>

          <div id="container">
            <span class="widget">Inner Widget</span>
          </div>
        HTML

        GivenWidget(Dill::Widget, :parent) { root '#container' }

        context "when child has a selector" do
          GivenWidget(Dill::Widget, :child) { root 'body > .widget' }

          Given { parent_class.widget :the_widget, '.widget', child_class }

          When(:widget) { parent.widget(:the_widget) }

          Then { widget.to_s == 'Inner Widget' }
        end

        context "when type has no selector" do
          GivenWidget Dill::Widget, :child

          Given { parent_class.widget :the_widget, '.widget', child_class }

          When(:widget) { parent.widget(:the_widget) }

          Then { widget.to_s == 'Inner Widget' }
        end
      end

      context "defining new behavior inline" do
        GivenHTML <<-HTML
          <span id="inline">Guybrush Threepwood</span>
        HTML

        GivenWidget do
          widget :inline, '#inline' do
            def inline!
              'yay'
            end
          end
        end

        context "using behavior defined inline" do
          When(:inline) { w.widget(:inline) }

          Then { inline.respond_to?(:inline!) == true }
        end
      end
    end

    describe "#==" do
      GivenWidget { root '#value' }

      context "straight comparison" do
        GivenHTML <<-HTML
          <span id="value">1</span>
        HTML

        Then { w == 1 }
        Then { w == '1' }
        Then { w == 1.0 }
      end

      context "delayed comparison" do
        GivenHTML <<-HTML
          <script>
            function changeValue() {
              var value = document.getElementById('value');

              value.innerHTML = 1;
            }

            setTimeout(changeValue, 500);
          </script>

          <span id="value">0</span>
        HTML

        Then { w == 1 }
        Then { w == '1' }
        Then { w == 1.0 }
      end
    end

    describe "#=~" do
      GivenHTML <<-HTML
        <span id="match">This matches</span>
      HTML

      GivenWidget { root '#match' }

      Then { w =~ /This m/ }
      Then { w !~ /No match/ }
    end

    describe "#!=" do
      GivenWidget { root '#value' }

      context "straight comparison" do
        GivenHTML <<-HTML
          <span id="value">1</span>
        HTML

        Then { w != 0 }
        Then { w != '0' }
        Then { w != 0.0 }
      end

      context "delayed comparison" do
        GivenHTML <<-HTML
          <script>
            function changeValue() {
              var value = document.getElementById('value');

              value.innerHTML = 0;
            }

            setTimeout(changeValue, 500);
          </script>

          <span id="value">1</span>
        HTML

        Then { w != 1 }
        Then { w != '1' }
        Then { w != 1.0 }
      end
    end

    describe "#has_action?" do
      GivenHTML <<-HTML
        <a href="#" id="present">Edit</a>
      HTML

      GivenWidget do
        action :present, '#present'
        action :absent, '#absent'
      end

      context "when action exists" do
        Then { w.has_action?(:present) }
      end

      context "when action is missing" do
        Then { ! w.has_action?(:absent) }
      end

      context "when the action is undefined" do
        When(:error) { w.has_action?(:undefined) }

        Then { error == Failure(Dill::Missing, /`undefined' action/) }
      end
    end

    describe "#has_widget?" do
      GivenHTML <<-HTML
        <span id="present">Guybrush Threepwood</span>
      HTML

      GivenWidget do
        widget :present, '#present'
        widget :absent, '#absent'
      end

      context "when widget exists" do
        Then { w.has_widget?(:present) }
      end

      context "when widget is missing" do
        Then { ! w.has_widget?(:absent) }
      end

      context "when widget is undefined" do
        When(:error) { w.has_widget?(:undefined) }

        Then { error == Failure(Dill::Missing, /`undefined' widget/) }
      end
    end

    describe "#inspect", if: driver == :webkit do
      GivenHTML <<-HTML
        <span id="ins">Ins</span>
      HTML

      GivenWidget do
        root 'span'

        def self.name
          'Inspect'
        end
      end

      When(:inspection) { w.inspect }

      Then { inspection == "<!-- Inspect: -->\n<span id=\"ins\">Ins</span>\n" }
    end

    describe "#inspect", if: driver != :webkit do
      GivenHTML <<-HTML
        <p>
          <span id="ins">Ins</span>
        </p>
      HTML

      GivenWidget do
        root 'p'

        def self.name
          'Inspect'
        end
      end

      When(:inspection) { w.inspect }

      Then { inspection == "<!-- Inspect: -->\n<p>\nIns" }
    end
    describe "#match" do
      GivenHTML <<-HTML
        <span id="match">This matches</span>
      HTML

      GivenWidget { root '#match' }

      context "simple match" do
        Then { w.match(/This m/) }
      end

      context "match with block" do
        When(:result) { w.match(/This m/) { |m| 'w00t!' } }

        Then { result == 'w00t!' }
      end

      context "no match" do
        Then { ! w.match(/No match/) }
      end

      context "no match with position" do
        Then { ! w.match(/This mat/, 2) }
      end
    end

    describe "#reload" do
      context "when widget content changes", js: true do
        GivenHTML <<-HTML
          <script>
            function removeNode() {
              var victim = document.getElementById('remove');

              document.body.removeChild(victim);
            }

            setTimeout(removeNode, 500);
          </script>

          <span id="remove">Guybrush Threepwood</span>
        HTML

        GivenWidget { widget :removed, '#remove' }

        Then { ! w.reload.has_widget?(:removed) }
      end

      context "when the widget node is replaced" do
        GivenHTML <<-HTML
          <script>
            function removeNode() {
              var victim = document.getElementById('remove');

              document.body.removeChild(victim);
            }

            setTimeout(removeNode, 500);
          </script>

          <span id="remove">Guybrush Threepwood</span>
        HTML

        GivenWidget { root '#remove' }

        When(:failure) { w.reload }

        Then { failure == Failure(Dill::Widget::Removed) }
      end

      context "when widget remains the same", js: true do
        GivenHTML <<-HTML
          <span id="present">Guybrush Threepwood</span>
        HTML

        GivenWidget { widget :present, '#present' }

        Then { w.reload.has_widget?(:present) }
      end
    end
  end
end
