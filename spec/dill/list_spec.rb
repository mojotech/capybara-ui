require 'spec_helper'

describe Dill::List do
  describe ".empty?" do
    GivenWidget Dill::List do
      root 'ul'
      item 'li'
    end

    context "when the list is empty" do
      GivenHTML <<-HTML
        <ul>
        </ul>
      HTML

      Then { w.empty? == true }
    end

    context "when the list is not" do
      GivenHTML <<-HTML
        <ul>
          <li>Item<li>
        </ul>
      HTML

      Then { w.empty? == false }
    end
  end
end
