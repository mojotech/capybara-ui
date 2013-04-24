module Cucumber
  module Salad
    module Widgets
      class Atom < Widget
        def to_a
          [to_s]
        end

        def ==(other)
          to_s.downcase == other.to_s.downcase
        end

        def to_s
          node_text(root)
        end
      end
    end
  end
end
