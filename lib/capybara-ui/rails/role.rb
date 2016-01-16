module CapybaraUI
  module Rails
    class Role < ActionDispatch::IntegrationTest
      def initialize
        super self.class.name
      end
    end
  end
end
