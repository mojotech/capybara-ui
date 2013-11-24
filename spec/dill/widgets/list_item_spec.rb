require 'spec_helper'

describe Dill::ListItem do
  GivenHTML <<-HTML
    <span id="item">Item</span>
  HTML

  GivenWidget do
    class ListItem < Dill::ListItem
      root '#item'
    end
  end

  describe '#to_row' do
    When(:row) { widget(:list_item).to_row }

    Then { row == ['Item'] }
  end
end
