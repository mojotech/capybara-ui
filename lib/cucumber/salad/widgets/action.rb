module Cucumber
  module Salad
    module Widgets
      class Action < Atom
        def_delegators :root, :click
      end
    end
  end
end
