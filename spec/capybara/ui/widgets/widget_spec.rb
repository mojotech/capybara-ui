require 'spec_helper'
require 'cucumber'

DRIVERS.each do |driver|
  describe Capybara::UI::Widget, "using #{driver}", js: true, driver: driver do
    describe '.root' do
      context 'simple selector' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
            root '.selector'
          end
        end

        Then { MyWidget.selector == ['.selector'] }
      end

      context 'composite selector' do
        context 'using splat' do
          GivenWidget do
            class MyWidget < Capybara::UI::Widget
              root '.selector', text: 'something'
            end
          end

          Then { MyWidget.selector == ['.selector', text: 'something'] }
        end

        context 'using array' do
          GivenWidget do
            class MyWidget < Capybara::UI::Widget
              root ['.selector', text: 'something']
            end
          end

          Then { MyWidget.selector == ['.selector', text: 'something'] }
        end
      end
    end

    describe '.widget_delegator' do
      GivenHTML <<-HTML
        <div>
          <span id="child">Ins</span>
        </div>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
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
        class MyWidget < Capybara::UI::Widget
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
          class Link < Capybara::UI::Widget
            root 'a'
          end
        end

        When       { widget(:link).click }
        When(:url) { Capybara.current_session.current_url }

        Then { url =~ %r{/destination} }
      end

      context 'clicking a child widget' do
        GivenWidget do
          class Container < Capybara::UI::Widget
            root 'body'

            widget :link, 'a'
          end
        end

        When       { widget(:container).click :link  }
        When(:url) { Capybara.current_session.current_url }

        Then { url =~ %r{/destination} }
      end
    end

    describe '#hover' do
      GivenHTML <<-HTML
        <span onmouseover="this.innerHTML = 'Hovered!'">Hover Me!</span>
      HTML

      context 'hovering over a widget' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
            root 'span'
          end
        end

        When { widget(:my_widget).hover }

        Then { widget(:my_widget).text == "Hovered!" }
      end

      context 'hovering over a child widget' do
        GivenWidget do
          class Container < Capybara::UI::Widget
            root 'body'

            widget :my_widget, 'span'
          end
        end

        When { widget(:container).hover :my_widget  }

        Then { widget(:container).text == "Hovered!" }
      end
    end

    describe '#double_click' do
      GivenHTML <<-HTML
        <span ondblclick="this.innerHTML = 'Double Clicked!'">Double Click Me!</span>
      HTML

      context 'double clicking a widget' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
            root 'span'
          end
        end

        When { widget(:my_widget).double_click }

        Then { widget(:my_widget).text == "Double Clicked!" }
      end

      context 'double clicking a child widget' do
        GivenWidget do
          class Container < Capybara::UI::Widget
            root 'body'

            widget :my_widget, 'span'
          end
        end

        When { widget(:container).double_click :my_widget  }

        Then { widget(:container).text == "Double Clicked!" }
      end
    end

    describe '#right_click', if: driver == :webkit do
      GivenHTML <<-HTML
        <span oncontextmenu="this.innerHTML = 'Right Clicked!'">Right Click Me!</span>
      HTML

      context 'right clicking a widget' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
            root 'span'
          end
        end

        When { widget(:my_widget).right_click }

        Then { widget(:my_widget).text == "Right Clicked!" }
      end

      context 'right clicking a child widget' do
        GivenWidget do
          class Container < Capybara::UI::Widget
            root 'body'

            widget :my_widget, 'span'
          end
        end

        When { widget(:container).right_click :my_widget  }

        Then { widget(:container).text == "Right Clicked!" }
      end
    end

    describe 'diff' do
      GOOD_TABLE = [{'a' => '1', 'b' => '2'}, {'a' => '3', 'b' => '4'}]

      GivenHTML <<-HTML
        <div>Widget</div>
      HTML

      Given(:table) { Cucumber::Ast::Table.new(GOOD_TABLE) }

      context 'successful comparison' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
            root 'div'

            define_method(:to_table) { GOOD_TABLE }
          end
        end

        When(:success) { widget(:my_widget).diff table }

        Then { success == true }
      end

      context 'failed comparison' do
        GivenWidget do
          class MyWidget < Capybara::UI::Widget
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
        class MyWidget < Capybara::UI::Widget
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

        Then { error == Failure(Capybara::UI::Missing, /`undefined' action/) }
      end
    end

    describe '#has_widget?' do
      GivenHTML <<-HTML
        <span id="present">Guybrush Threepwood</span>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
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

        Then { error == Failure(Capybara::UI::Missing, /`undefined' widget/) }
      end
    end

    describe '#visible?' do
      GivenHTML <<-HTML
        <span id="visible">Example Item</span>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
          root 'body'

          widget :visible, '#visible'
          widget :not_visible, '#not_visible'
        end
      end

      context 'when widget exists' do
        Then { widget(:my_widget).visible?(:visible) }
      end

      context 'when widget is missing' do
        Then { ! widget(:my_widget).visible?(:not_visible) }
      end

      context 'when widget is undefined' do
        When(:error) { widget(:my_widget).visible?(:undefined) }

        Then { error == Failure(Capybara::UI::Missing, /`undefined' widget/) }
      end
    end


    describe '#not_visible?' do
      GivenHTML <<-HTML
        <span id="visible">Example Item</span>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
          root 'body'

          widget :visible, '#visible'
          widget :not_visible, '#not_visible'
        end
      end

      context 'when widget exists' do
        Then { ! widget(:my_widget).not_visible?(:visible) }
      end

      context 'when widget is missing' do
        Then { widget(:my_widget).not_visible?(:not_visible) }
      end

      context 'when widget is undefined' do
        When(:error) { widget(:my_widget).not_visible?(:undefined) }

        Then { error == Failure(Capybara::UI::Missing, /`undefined' widget/) }
      end
    end

    describe '#html', if: driver == :webkit do
      GivenHTML <<-HTML
        <span id="html" class="one">HTML</span>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
          root 'span'
        end
      end

      When(:html) { widget(:my_widget).html }

      Then { html == "<span id=\"html\" class=\"one\">HTML</span>" }
    end

    describe '#html', if: driver != :webkit do
      GivenHTML <<-HTML
        <span id="html" class="one">HTML</span>
      HTML

      GivenWidget do
        class MyWidget < Capybara::UI::Widget
          root 'span'
        end
      end

      pending do # FIXME: It's not clear what this failing test should be testing.
        When(:html) { widget(:my_widget).html }

        Then { html == Failure(Capybara::NotSupportedByDriverError) }
      end
    end
  end
end
