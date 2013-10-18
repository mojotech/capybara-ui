require 'spec_helper'

class Top < Dill::Widget
  root '#top'
end

module WidgetNS
  class Inner < Dill::Widget
  end
end

describe Dill::DSL do
  include Dill::DSL

  GivenHTML <<-HTML
    <span id="top">Top Widget</span>
  HTML

  describe '#widget' do
    context 'when the widget is at the top level' do
      Then { widget(:top).class == Top }
    end

    context 'when the widget is unknown' do
      When(:error) { widget(:unknown) }

      Then { error == Failure(Dill::Missing) }
    end

    context 'when the widget is not at the top level' do
      When(:error) { widget(:inner) }

      Then { error == Failure(Dill::Missing) }
    end
  end
end
