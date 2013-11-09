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
        root '#container'

        widget :multiple, lambda { |text| ['.multiple', text: text] }
      end

      When(:widget) { w.widget(:multiple, 'Right') }

      Then { widget == 'Right' }
    end
  end
end
