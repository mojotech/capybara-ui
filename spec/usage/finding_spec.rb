require 'spec_helper'

describe 'Finding a widget' do
  describe 'Finding multiple nodes' do
    GivenHTML <<-HTML
      <span class="my-widget">Hi, world!</span>
      <span class="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class Single < CapybaraUI::Widget
        root '.my-widget'
      end
    end

    When(:values) { widgets(:single).map(&:text) }

    Then { values == ['Hi, world!', 'Hello, world!'] }
  end

  describe 'Using a simple selector (short form)' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      ShortForm = CapybaraUI::Widget('#my-widget')
    end

    Then { widget(:short_form).is_a?(ShortForm) }
  end

  describe 'Using a composite selector (short form)' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      CompositeForm = CapybaraUI::Widget('.multiple', text: 'Right')
    end

    Then { widget(:composite_form).text == 'Right' }
    Then { widget(:composite_form).is_a?(CompositeForm) }
  end

  context 'Using a lazy selector (short form)' do
    GivenHTML <<-HTML
      <span class="multiple">Right</span>
      <span class="multiple">Wrong</span>
    HTML

    GivenWidget do
      LazyForm = CapybaraUI::Widget(->(text){ ['.multiple', text: text] })
    end

    Then { widget(:lazy_form, 'Right').text == 'Right' }
    And { widget(:lazy_form, 'Right').is_a?(LazyForm)}
  end
end
