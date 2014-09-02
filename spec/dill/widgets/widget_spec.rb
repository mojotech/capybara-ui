require 'spec_helper'
require 'cucumber'

DRIVERS.each do |driver|
  describe Dill::Widget, "using #{driver}", js: true, driver: driver do
    describe '.root' do
      context 'simple selector' do
        GivenWidget do
          class MyWidget < Dill::Widget
            root '.selector'
          end
        end

        Then { MyWidget.selector == ['.selector'] }
      end

      context 'composite selector' do
        context 'using splat' do
          GivenWidget do
            class MyWidget < Dill::Widget
              root '.selector', text: 'something'
            end
          end

          Then { MyWidget.selector == ['.selector', text: 'something'] }
        end

        context 'using array' do
          GivenWidget do
            class MyWidget < Dill::Widget
              root ['.selector', text: 'something']
            end
          end

          Then { MyWidget.selector == ['.selector', text: 'something'] }
        end
      end
    end

    describe '.widget_delegator' do
      GivenWidget do
        class MyWidget < Dill::Widget
          root 'div'

          widget :child, '#child' do
            def inline!
              'yay!'
            end
          end

          widget_delegator :child, :inline!
          widget_delegator :child, :inline!, :outline!
        end
      end

      Then { widget(:my_widget).respond_to?(:inline!) }
      Then { widget(:my_widget).respond_to?(:outline!) }
    end

    describe '#==' do
      GivenWidget do
        class MyWidget < Dill::Widget
          root '#value'
        end
      end

      GivenHTML <<-HTML
        <span id="value">1</span>
      HTML

      Then { widget(:my_widget).value == '1' }
    end

    describe '#click' do
      GivenAction <<-HTML, '/destination'
        Congratulations!
      HTML

      GivenHTML <<-HTML
        <a href="/destination" id="present">Edit</a>
      HTML

      context 'clicking a widget' do
        GivenWidget do
          class Link < Dill::Widget
            root 'a'
          end
        end

        When       { widget(:link).click }
        When(:url) { Capybara.current_session.current_url }

        Then { url =~ %r{/destination} }
      end

      context 'clicking a child widget' do
        GivenWidget do
          class Container < Dill::Widget
            root 'body'

            widget :link, 'a'
          end
        end

        When       { widget(:container).click :link  }
        When(:url) { Capybara.current_session.current_url }

        Then { url =~ %r{/destination} }
      end
    end

    describe 'diff' do
      GOOD_TABLE = [{'a' => '1', 'b' => '2'}, {'a' => '3', 'b' => '4'}]

      Given(:table) { Cucumber::Ast::Table.new(GOOD_TABLE) }

      context 'successful comparison' do
        GivenWidget do
          class MyWidget < Dill::Widget
            root 'div'

            define_method(:to_table) { GOOD_TABLE }
          end
        end

        When(:success) { widget(:my_widget).diff table }

        Then { success == true }
      end

      context 'failed comparison' do
        GivenWidget do
          class MyWidget < Dill::Widget
            root 'div'

            define_method(:to_table) { [{'a' => '5', 'b' => '6'}] }
          end
        end

        When(:failure) { widget(:my_widget).diff table }

        Then { failure == Failure(Cucumber::Ast::Table::Different) }
      end
    end

    describe '#has_action?' do
      GivenHTML <<-HTML
        <a href="#" id="present">Edit</a>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'body'

          action :present, '#present'
          action :absent, '#absent'
        end
      end

      context 'when action exists' do
        Then { widget(:my_widget).has_action?(:present) }
      end

      context 'when action is missing' do
        Then { ! widget(:my_widget).has_action?(:absent) }
      end

      context 'when the action is undefined' do
        When(:error) { widget(:my_widget).has_action?(:undefined) }

        Then { error == Failure(Dill::Missing, /`undefined' action/) }
      end
    end

    describe '#has_widget?' do
      GivenHTML <<-HTML
        <span id="present">Guybrush Threepwood</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'body'

          widget :present, '#present'
          widget :absent, '#absent'
        end
      end

      context 'when widget exists' do
        Then { widget(:my_widget).has_widget?(:present) }
      end

      context 'when widget is missing' do
        Then { ! widget(:my_widget).has_widget?(:absent) }
      end

      context 'when widget is undefined' do
        When(:error) { widget(:my_widget).has_widget?(:undefined) }

        Then { error == Failure(Dill::Missing, /`undefined' widget/) }
      end
    end

    describe '#inspect', if: driver == :webkit do
      GivenHTML <<-HTML
        <span id="ins">Ins</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'span'

          def self.name
            'Inspect'
          end
        end
      end

      When(:inspection) { widget(:my_widget).inspect }

      Then { inspection == "<!-- Inspect: -->\n<span id=\"ins\">Ins</span>\n" }
    end

    describe '#inspect', if: driver != :webkit do
      GivenHTML <<-HTML
        <p>
          <span id="ins">Ins</span>
        </p>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'p'

          def self.name
            'Inspect'
          end
        end
      end

      When(:inspection) { widget(:my_widget).inspect }

      Then { inspection == "<!-- Inspect: -->\n<p>\nIns" }
    end

    describe 'inspecting detached node' do
      GivenHTML <<-HTML
        <span id="ins">Ins</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'body'

          widget :child, 'a'
        end
      end

      When(:inspection) { widget(:my_widget).widget(:child).inspect }

      Then { inspection == '#<DETACHED>' }
    end

    context 'when the widget is absent' do
      GivenHTML ''

      GivenWidget do
        class MyWidget < Dill::Widget
          root 'a'
        end
      end

      Then { widget(:my_widget).gone? }
      And { widget(:my_widget).absent? }
    end

    context 'when the widget is present' do
      GivenHTML <<-HTML
        <span id="present">Present</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root '#present'
        end
      end

      Then { widget(:my_widget).present? }
      And { ! widget(:my_widget).absent? }
    end
  end
end
