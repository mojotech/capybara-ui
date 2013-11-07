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
        root '#single'
      end

      When(:widget) { w_class.find_in(document) }

      Then { widget == 'Content' }
    end

    context 'the widget can be targeted by a composite selector' do
      GivenHTML <<-HTML
        <span class="multiple">Right</span>
        <span class="multiple">Wrong</span>
      HTML

      GivenWidget do
        root '.multiple', text: 'Right'
      end

      When(:widget) { w_class.find_in(document) }

      Then { widget == 'Right' }
    end

    context 'the widget can be targeted by a lazy selector' do
      GivenHTML <<-HTML
        <span class="multiple">Right</span>
        <span class="multiple">Wrong</span>
      HTML

      GivenWidget do
        root { |text| ['.multiple', text: text] }
      end

      When(:widget) { w_class.find_in(document, 'Right') }

      Then { widget == 'Right' }
    end

    context "the widget can't be targeted unambiguously" do
      GivenHTML <<-HTML
        <span class="multiple">First</span>
        <span class="multiple">Second</span>
      HTML

      GivenWidget do
        root '.multiple'
      end

      Given(:widget) { w_class.find_in(document) }

      When(:ambiguous) { widget.value }

      Then { ambiguous == Failure(Capybara::Ambiguous) }
    end

    context "the widget root doesn't exist" do
      GivenHTML <<-HTML
        <span id="single">Single</span>
      HTML

      GivenWidget do
        root '#none'
      end

      Given(:widget) { w_class.find_in(document) }

      When(:missing) { widget.value }

      Then { missing == Failure(Capybara::ElementNotFound) }
    end
  end
end
