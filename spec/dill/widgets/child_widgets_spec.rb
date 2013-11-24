require 'spec_helper'

DRIVERS.each do |driver|
  describe "Using child widgets (#{driver})", driver: driver do
    context 'the child widget can be targeted by a lazy selector' do
      GivenHTML <<-HTML
        <div id="container">
          <span class="multiple">Right</span>
          <span class="multiple">Wrong</span>
        </div>
      HTML

      GivenWidget do
        class Container < Dill::Widget
          root '#container'

          widget :multiple, lambda { |text| ['.multiple', text: text] }
        end
      end

      When(:w) { widget(:container).widget(:multiple, 'Right') }

      Then { w == 'Right' }
    end
  end
end
