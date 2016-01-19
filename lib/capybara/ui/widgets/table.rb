module Capybara
  module UI
    class Table < Capybara::UI::Widget
      root 'table'

      class Row < Capybara::UI::List
        def self.column(*args, &block)
          item(*args, &block)
        end
      end

      def self.header_row(selector, &block)
        widget :header_row, selector, Row, &block
      end

      header_row 'thead tr' do
        column 'th'
      end

      def self.data_row(selector, &block)
        widget :data_row, selector, Row, &block
      end

      data_row 'tbody tr' do
        column 'td'
      end

      class Columns
        include Enumerable

        def initialize(parent)
          @parent = parent
        end

        def [](header_or_index)
          case header_or_index
          when Integer
            values_by_index(header_or_index)
          when String
            values_by_header(header_or_index)
          else
            raise TypeError,
                  "can't convert #{header_or_index.inspect} to Integer or String"
          end
        end

        def each(&block)
          parent.each(&block)
        end

        private

        attr_reader :parent

        def values_by_index(index)
          parent.rows.transpose[index]
        end

        def values_by_header(header)
          values_by_index(find_header_index(header))
        end

        def find_header_index(header)
          parent.widget(:header_row).value.find_index(header) or
            raise ArgumentError, "header not found: #{header.inspect}"
        end
      end

      def columns
        Columns.new(self)
      end

      def rows
        widgets(:data_row).map(&:value)
      end
    end
  end
end
