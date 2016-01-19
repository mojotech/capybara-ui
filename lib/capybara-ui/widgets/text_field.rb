module Capybara
  module UI
    # A text field.
    class TextField < Field
      # @!method get
      #   @return The text field value.
      def_delegator :root, :value, :get

      # @!method set(value)
      #   Sets the text field value.
      #
      #   @param value [String] the value to set.
      def_delegator :root, :set

      # @!method to_s
      #   @return the text field value, or the empty string if the field is
      #     empty.
      def_delegator :get, :to_s

      def to_cell
        get
      end

      def content?
        get.respond_to?(:empty?) ? ! get.empty? : !! get
      end
    end
  end
end
