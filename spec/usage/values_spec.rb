require 'spec_helper'
require 'spec_helper'

describe 'Widget values' do
  describe 'Widgets as values' do
    GivenHTML <<-HTML
      <span id="my-widget">1</span>
    HTML

    GivenWidget do
      Int = CapybaraUI::Widget('#my-widget') { |text| text.to_i }
    end

    Then { value(:int) == 1 }
  end

  describe 'Widgets as strings' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      Str = CapybaraUI::String('#my-widget')
    end

    Then { value(:str) == 'Hello, world!' }
  end

  describe 'Passing more arguments to #value' do
    GivenHTML <<-HTML
      <span id="my-widget-1">Hello, world!</span>
      <span id="my-widget-2">Goodbye, world!</span>
    HTML

    GivenWidget do
      class Str < CapybaraUI::Widget
        root { |n| "#my-widget-#{n}" }
      end
    end

    Then { value(:str, 2) == 'Goodbye, world!' }
  end

  describe 'Widgets as integers' do
    context 'Widget content can be cast to an integer' do
      GivenHTML <<-HTML
        <span id="my-widget">1</span>
      HTML

      GivenWidget do
        Int = CapybaraUI::Integer('#my-widget')
      end

      Then { value(:int) == 1 }
    end

    context 'Widget content cannot be cast to an integer' do
      GivenHTML <<-HTML
        <span id="my-widget">String</span>
      HTML

      GivenWidget do
        Int = CapybaraUI::Integer('#my-widget')
      end

      When(:result) { value(:int) }

      Then { result == Failure(ArgumentError, /invalid value for Integer()/) }
    end
  end

  describe 'Lists of values' do
    GivenHTML <<-HTML
      <span class="my-widget">Hi, world!</span>
      <span class="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class Single < CapybaraUI::Widget
        root '.my-widget'
      end
    end

    When(:vals) { values(:single) }

    Then { vals == ['Hi, world!', 'Hello, world!'] }
  end

  describe 'Widgets as decimals' do
    context 'Widget content can be cast to a float' do
      GivenHTML <<-HTML
        <span id="my-widget">1.5</span>
      HTML

      GivenWidget do
        Dec = CapybaraUI::Decimal('#my-widget')
      end

      Then { value(:dec) == 1.5 }
      And { value(:dec).is_a?(BigDecimal) } # ensure precision
    end

    context 'Widget content cannot be cast to a float' do
      GivenHTML <<-HTML
        <span id="my-widget">String</span>
      HTML

      GivenWidget do
        Dec = CapybaraUI::Decimal('#my-widget')
      end

      When(:result) { value(:dec) }

      Then { result == Failure(ArgumentError, /invalid value for Float()/) }
    end
  end
end
