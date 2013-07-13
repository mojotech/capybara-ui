module Cucumber
  module Salad
    module Widgets
      class Action < Widget
        def_delegators :root, :click
      end
    end
  end
end
