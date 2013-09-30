module Dill
  class NodeText < String
    include InstanceConversions

    def initialize(node)
      super node.text.strip
    end
  end
end
