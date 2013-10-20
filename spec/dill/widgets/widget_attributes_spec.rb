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
    </div>
  HTML

  GivenWidget do
    root '#container'

    string :name, '#name'
    integer :age, '#age'
    float :weight, '#weight'
    date :active_since, '#active-since'
    time :last_seen_on, '#last-seen'
    boolean :pirate, '#is-pirate'
  end

  Then { w.name == 'Guybrush Threepwood' }
  Then { w.age == 21 }
  Then { w.weight == 185.5 }
  Then { w.active_since == Date.civil(1990, 10, 1) }
  Then { w.last_seen_on == Time.local(2009, 12, 8, 23, 33) }
  Then { w.pirate? }
end
