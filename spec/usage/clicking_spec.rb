require 'spec_helper'

describe 'Clicking Widgets' do
  GivenAction <<-HTML, '/success'
    <span>Success!</span>
  HTML

  GivenAction <<-HTML, '/nooo'
    <span>Nooo!<span>
  HTML

  GivenHTML <<-HTML
   <a href="/nooo" class="my-widget">One</li>
   <a href="/success" class="my-widget">Two</li>
  HTML

  GivenWidget do
    class MyWidget < Capybara::UI::Widget
      root { |text| ['.my-widget', text: text] }
    end
  end

  When { click :my_widget, 'Two' }

  Then { page.text =~ /Success!/ }
end
