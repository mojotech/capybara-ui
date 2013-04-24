module Cucumber
  module Salad
    class NodeText < String
      def initialize(node)
        super node.text.strip
      end
    end
  end
end
