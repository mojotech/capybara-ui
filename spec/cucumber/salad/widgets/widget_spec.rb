require 'spec_helper'

describe Cucumber::Salad::Widgets::Widget do
  describe "#has_widget?" do
    GivenHTML <<-HTML
      <span id="present">Guybrush Threepwood</span>
    HTML

    class Container < Cucumber::Salad::Widgets::Widget
      widget :present, '#present'
      widget :absent, '#absent'
    end

    context "when widget exists" do
      Then { container.has_widget?(:present) }
    end

    context "when widget is missing" do
      Then { ! container.has_widget?(:absent) }
    end

    context "when widget is undefined" do
      When(:error) { container.has_widget?(:undefined) }

      Then { error == Failure(Cucumber::Salad::UnknownWidgetError, /`undefined' widget/) }
    end
  end
end
