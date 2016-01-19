module Capybara
  module UI
    module Rails
      class Role < ActionDispatch::IntegrationTest
        def initialize
          super self.class.name
        end
      end
    end
  end
end
