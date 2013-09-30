require 'spec_helper'

describe Dill::ListItem do
  GivenHTML <<-HTML
    <span id="item">Item</span>
  HTML

  GivenWidget Dill::ListItem do
    root '#item'
  end

  describe "#to_row" do
    When(:row) { w.to_row }

    Then { row == ["Item"] }
  end
end
