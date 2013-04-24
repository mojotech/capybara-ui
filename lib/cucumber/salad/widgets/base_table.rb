module Cucumber
  module Salad
    module Widgets
      class BaseTable < Widget
        def to_table
          ensure_table_loaded

          headers.any? ? [headers, *values] : values
        end
      end
    end
  end
end
