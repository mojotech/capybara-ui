require 'spec_helper'

class Top < Cucumber::Salad::Widgets::Widget
  root '#top'
end

module WidgetNS
  class Inner < Cucumber::Salad::Widgets::Widget
  end
end

describe Cucumber::Salad::DSL do
  include Cucumber::Salad::DSL

  GivenHTML <<-HTML
    <span id="top">Top Widget</span>
  HTML

  describe '#widget' do
    context "when the widget is at the top level" do
      Then { widget(:top).class == Top }
    end

    context "when the widget is unknown" do
      When(:error) { widget(:unknown) }

      Then { error == Failure(Cucumber::Salad::Missing) }
    end

    context "when the widget is not at the top level" do
      When(:error) { widget(:inner) }

      Then { error == Failure(Cucumber::Salad::Missing) }
    end
  end
end
