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

      Then { error == Failure(Cucumber::Salad::Missing, /`undefined' widget/) }
    end
  end

  describe "#has_action?" do
    GivenHTML <<-HTML
      <a href="#" id="present">Edit</a>
    HTML

    class Container < Cucumber::Salad::Widgets::Widget
      action :present, '#present'
      action :absent, '#absent'
    end

    context "when action exists" do
      Then { container.has_action?(:present) }
    end

    context "when action is missing" do
      Then { ! container.has_action?(:absent) }
    end

    context "when the action is undefined" do
      When(:error) { container.has_action?(:undefined) }

      Then { error == Failure(Cucumber::Salad::Missing, /`undefined' action/) }
    end
  end
end
