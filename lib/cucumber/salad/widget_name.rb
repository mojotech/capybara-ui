module Cucumber
  module Salad
    # The name of a widget in a format-independent representation.
    class WidgetName < String
      CAMEL_CASE_FORMAT = /\A([A-Z][a-z]*)+\Z/
      SNAKE_CASE_FORMAT = /\A\w+\Z/

      # Constructs the widget name.
      #
      # @param name [String, Symbol] the name of the widget in primitive form
      def initialize(name)
        @name      = name
        @canonical = canonical(@name)
      end

      # Returns the class for this widget name, in the given scope.
      def to_class(scope = Object)
        const = scope.const_get(@canonical)

        raise TypeError, "`#{@canonical}' is not a widget in this scope" \
          unless const < Widgets::Widget

        const
      rescue NameError
        raise UnknownWidgetError,
              "couldn't find `#{@name}' widget in this scope"
      end

      def to_sym
        @canonical.to_sym
      end

      private

      def canonical(name)
        str = name.to_s

        case str
        when SNAKE_CASE_FORMAT
          camel_case_from_snake_case(str)
        when CAMEL_CASE_FORMAT
          str
        else
          raise ArgumentError, "can't convert `#{str.inspect}' to canonical form"
        end
      end

      def camel_case_from_snake_case(name)
        capitalize_word = ->(word) { word[0].upcase + word[1..-1] }
        word_separator  = '_'

        name
          .split(word_separator)
          .map(&capitalize_word)
          .join
      end
    end
  end
end
