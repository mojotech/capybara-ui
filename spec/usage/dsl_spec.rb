require 'spec_helper'

describe 'Basic usage' do
  describe 'The simplest widget' do
    GivenHTML <<-HTML
      <span id="my-widget">Hello, world!</span>
    HTML

    GivenWidget do
      class Simplest < Dill::Widget
        root '#my-widget'
      end
    end

    Then { widget(:simplest).is_a?(Simplest) }
  end
end
