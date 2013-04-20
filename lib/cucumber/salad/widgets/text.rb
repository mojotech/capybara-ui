module Cucumber
  module Salad
    module Widgets
      class Text < Widget
        def to_a
          [to_s]
        end

        def ==(other)
          to_s.downcase == other.to_s.downcase
        end

        def to_s
          root.text.strip
        end
      end
    end
  end
end
