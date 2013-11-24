require 'spec_helper'

DRIVERS.each do |driver|
  describe "Finding a widget (#{driver})", driver: driver do
    context 'the widget can be targeted by a simple selector' do
      GivenHTML <<-HTML
        <div id="container">
          <span id="single">Content</span>
        </div>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root '#single'
        end
      end

      When(:w) { MyWidget.find_in(document) }

      Then { w == 'Content' }
    end

    context 'the widget can be targeted by a composite selector' do
      GivenHTML <<-HTML
        <span class="multiple">Right</span>
        <span class="multiple">Wrong</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root '.multiple', text: 'Right'
        end
      end

      When(:w) { MyWidget.find_in(document) }

      Then { w == 'Right' }
    end

    context 'the widget can be targeted by a lazy selector' do
      GivenHTML <<-HTML
        <span class="multiple">Right</span>
        <span class="multiple">Wrong</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root { |text| ['.multiple', text: text] }
        end
      end

      When(:w) { MyWidget.find_in(document, 'Right') }

      Then { w == 'Right' }
    end

    context "the widget can't be targeted unambiguously" do
      GivenHTML <<-HTML
        <span class="multiple">First</span>
        <span class="multiple">Second</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root '.multiple'
        end
      end

      Given(:w) { MyWidget.find_in(document) }

      When(:ambiguous) { w.value }

      Then { ambiguous == Failure(Capybara::Ambiguous) }
    end

    context "the widget root doesn't exist" do
      GivenHTML <<-HTML
        <span id="single">Single</span>
      HTML

      GivenWidget do
        class MyWidget < Dill::Widget
          root '#none'
        end
      end

      Given(:w) { MyWidget.find_in(document) }

      When(:missing) { w.value }

      Then { missing == Failure(Capybara::ElementNotFound) }
    end
  end
end
