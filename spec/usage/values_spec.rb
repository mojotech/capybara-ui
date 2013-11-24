require 'spec_helper'

describe 'Widget values' do
  describe 'Widgets as strings' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      Str = Dill::String('#my-widget')
    end

    Then { value(:str) == 'Hello, world!' }
  end

  describe 'Widgets as integers' do
    context 'Widget content can be cast to an integer' do
      GivenHTML <<-HTML
        <span id="my-widget">1</span>
      HTML

      GivenWidget do
        Int = Dill::Integer('#my-widget')
      end

      Then { value(:int) == 1 }
    end

    context 'Widget content cannot be cast to an integer' do
      GivenHTML <<-HTML
        <span id="my-widget">String</span>
      HTML

      GivenWidget do
        Int = Dill::Integer('#my-widget')
      end

      When(:result) { value(:int) }

      Then { result == Failure(ArgumentError, /invalid value for Integer()/) }
    end
  end
end
