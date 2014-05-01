require 'spec_helper'

describe 'Finding a widget' do
  describe 'Finding multiple nodes' do
    GivenHTML <<-HTML
      <span class="my-widget">Hi, world!</span>
      <span class="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class Single < Dill::Widget
        root '.my-widget'
      end
    end

    When(:values) { widgets(:single).map(&:text) }

    Then { values == ['Hi, world!', 'Hello, world!'] }
  end

  describe 'Using a simple selector' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class Simplest < Dill::Widget
        root '#my-widget'
      end
    end

    Then { widget(:simplest).text == 'Hello, world!' }
    And { widget(:simplest).is_a?(Simplest) }
  end

  describe 'Using a simple selector (short form)' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      ShortForm = Dill::Widget('#my-widget')
    end

    Then { widget(:short_form).is_a?(ShortForm) }
  end

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
    And { widget(:composite).is_a?(Composite)}
  end

  describe 'Using a composite selector (short form)' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      CompositeForm = Dill::Widget('.multiple', text: 'Right')
    end

    Then { widget(:composite_form).text == 'Right' }
    Then { widget(:composite_form).is_a?(CompositeForm) }
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
    And { widget(:lazy).is_a?(Lazy)}
  end

  context 'Using a lazy selector (short form)' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      LazyForm = Dill::Widget(->(text){ ['.multiple', text: text] })
    end

    Then { widget(:lazy_form, 'Right').text == 'Right' }
    And { widget(:lazy_form).is_a?(LazyForm)}
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
