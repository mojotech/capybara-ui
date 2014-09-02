module Dill
  module WidgetParts
    module Presence
      def absent?
        ! present?
      end

      def gone?
        absent?
      end
    end
  end
end
