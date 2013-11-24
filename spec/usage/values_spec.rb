require 'spec_helper'

describe 'Widget values' do
  describe 'Widgets as strings' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class WString < Dill::Widget
        root '#my-widget'
      end
    end

    Then { value(:w_string) == 'Hello, world!' }
  end
end
