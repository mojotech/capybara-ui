require 'spec_helper'
require 'pry'

class Top < CapybaraUI::Widget
  root '#top'
end

module WidgetNS
  class Inner < CapybaraUI::Widget
  end
end

describe CapybaraUI::DSL do
  GivenHTML <<-HTML
    <span id="top">Top Widget</span>
  HTML

  describe '#widget' do
    context 'when the widget is at the top level' do
      Then { widget(:top).class == Top }
    end

    context 'when the widget is unknown' do
      When(:error) { widget(:unknown) }

      Then { error == Failure(CapybaraUI::Missing) }
    end

    context 'when the widget is not at the top level' do
      When(:error) { widget(:inner) }

      Then { error == Failure(CapybaraUI::Missing) }
    end
  end

  describe '#eventually' do
    context 'when the block immediately passes' do
      When(:block) { lambda { true } }
      Then { eventually(&block) }
    end

    context 'when the block always fails' do
      When(:block) { lambda { false } }
      When(:result) { eventually(&block) }
      Then { result == Failure(CapybaraUI::Checkpoint::ConditionNotMet) }
    end

    context 'when the block succeeds within wait time' do
      When(:end_time) { Time.now + (Capybara.default_max_wait_time - 1) }
      When(:block) { lambda { Time.now > end_time } }
      Then { eventually(&block) }
    end

    context 'when the block would succeed only after wait time' do
      When(:end_time) { Time.now + (Capybara.default_max_wait_time + 1) }
      When(:block) { lambda { Time.now > end_time } }
      When(:result) { eventually(&block) }
      Then { result == Failure(CapybaraUI::Checkpoint::ConditionNotMet) }
    end

  end
end
