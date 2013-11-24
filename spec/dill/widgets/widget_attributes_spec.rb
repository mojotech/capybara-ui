require 'spec_helper'

describe 'Widget attributes' do
  GivenHTML <<-HTML
    <div id="container">
      <span id="name">Guybrush Threepwood</span>
      <span id="age">21</span>
      <span id="weight">185.5</span>
      <span id="active-since">October 1, 1990</span>
      <span id="last-seen">December 8, 2009 23:33</span>
      <span id="is-pirate">yes</span>
      <ul id="skills">
        <li class='skill'>Seafaring</li>
        <li class='skill'>Insult swordfighting</li>
        <li class='skill'>Long range spitting</li>
      </ul>
    </div>
  HTML

  GivenWidget do
    class MyWidget < Dill::Widget
      root '#container'

      string :name, '#name'
      integer :age, '#age'
      float :weight, '#weight'
      date :active_since, '#active-since'
      time :last_seen_on, '#last-seen'
      boolean :pirate, '#is-pirate'
      list :skills, '#skills', item_selector: '.skill'
    end
  end

  Then { widget(:my_widget).name == 'Guybrush Threepwood' }
  Then { widget(:my_widget).age == 21 }
  Then { widget(:my_widget).weight == 185.5 }
  Then { widget(:my_widget).active_since == Date.civil(1990, 10, 1) }
  Then { widget(:my_widget).last_seen_on == Time.local(2009, 12, 8, 23, 33) }
  Then { widget(:my_widget).pirate? }
  Then { widget(:my_widget).skills == ['Seafaring', 'Insult swordfighting', 'Long range spitting'] }
end
