require 'spec_helper'

describe 'Finding a widget' do
  context 'Using a composite selector' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      class Composite < Dill::Widget
        root '.multiple', text: 'Right'
      end
    end

    Then { widget(:composite).text == 'Right' }
  end

  context 'Using a lazy selector' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      class Lazy < Dill::Widget
        root { |text| ['.multiple', text: text] }
      end
    end

    Then { widget(:lazy, 'Right').text == 'Right' }
  end

  context 'Using an ambiguous selector' do
    GivenHTML <<-HTML
      <span class="multiple">First</span>
      <span class="multiple">Second</span>
    HTML

    GivenWidget do
      class Ambiguous < Dill::Widget
        root '.multiple'
      end
    end

    When(:result) { widget(:ambiguous).text }

    Then { result == Failure(Capybara::Ambiguous) }
  end

  context "the widget root doesn't exist" do
    GivenHTML <<-HTML
      <span id="single">Single</span>
    HTML

    GivenWidget do
      class Missing < Dill::Widget
        root '#none'
      end
    end

    When(:result) { widget(:missing).text }

    Then { result == Failure(Capybara::ElementNotFound) }
  end
end
