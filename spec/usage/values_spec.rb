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
end
