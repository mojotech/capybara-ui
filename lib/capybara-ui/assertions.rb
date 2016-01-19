module Capybara
  module UI
    module Assertions
      def assert_visible(role, widget_name, *args)
        eventually do
          assert role.see?(widget_name, *args)

          true
        end
      end

      def assert_not_visible(role, widget_name, *args)
        eventually do
          refute role.see?(widget_name, *args)

          true
        end
      end
    end
  end
end
