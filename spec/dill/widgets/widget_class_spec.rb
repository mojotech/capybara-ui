require 'spec_helper'

describe Dill::WidgetClass do
  describe '.new' do
    Given(:selector) { '.selector' }

    context 'passing only the selector' do
      Given(:widget_class) { Dill::WidgetClass.new(selector) }

      Then { widget_class < Dill::Widget }
      And { widget_class.selector == [selector] }
    end

    context 'passing the selector and type' do
      Given(:parent_class) { Class.new(Dill::Widget) { root '.parent' } }
      Given(:widget_class) { Dill::WidgetClass.new(selector, parent_class) }

      Then { widget_class < parent_class }
    end

    context 'passing the selector and extensions' do
      Given(:widget_class) {
        Dill::WidgetClass.new selector do
          def yay!
          end
        end
      }

      Then { widget_class.allocate.respond_to?(:yay!) }
    end
  end
end
