module Capybara
  module UI
    class StringValue < String
      def to_date(format = nil)
        if format
          Date.strptime(self, format)
        elsif defined?(super)
          super()
        else
          Date.parse(self)
        end
      end

      def to_key
        fst, rest = first, self[1..-1]
        decamelized = fst + rest.gsub(/([A-Z])/, '_\1')
        underscored = decamelized.gsub(/[\W_]+/, '_')
        stripped = underscored.gsub(/^_|_$/, '')
        downcased = stripped.downcase
        key = downcased.to_sym

        key
      end

      class Money
        extend Forwardable

        delegate %w(to_i to_f) => :str

        def initialize(str)
          fail ArgumentError, "can't convert `#{str}` to money" \
            unless str =~ /^-?\$\d+(?:,\d{3})*(?:\.\d+)?/

          @str = (str =~ /^-/ ? '-' : '') + str.gsub(/^-?\$|,/, '')
        end

        private

        attr_reader :str
      end

      def to_usd
        Money.new(self)
      end

      def to_split
        split(',').map(&:strip).map { |e| self.class.new(e) }
      end
    end
  end
end
