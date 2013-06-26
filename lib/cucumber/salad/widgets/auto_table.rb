module Cucumber
  module Salad
    module Widgets
      class AutoTable < BaseTable
        protected

        def ensure_table_loaded
          root.find(data_row_selector)
        rescue Capybara::Ambiguous
        end

        private

        def data_cell_selector
          'td'
        end

        def data_row(node)
          Row.new(root: node, cell_selector: data_cell_selector)
        end

        def data_row_selector
          'tbody tr'
        end

        def data_rows
          @data_rows ||= root.all(data_row_selector).map { |n| data_row(n) }
        end

        def header_selector
          'thead th'
        end

        def headers
          @headers ||= root.all(header_selector).map { |n| header_text(n) }
        end

        def values
          @values ||= data_rows.map(&:values)
        end

        def header_text(node)
          (node_text(node).presence ||
           node.first('[title]').try(:[], :title) ||
           node.first('[alt]').try(:[], :alt) ||
           "").downcase
        end


        class Row < Widget
          def initialize(settings)
            s = settings.dup

            self.cell_selector = s.delete(:cell_selector)

            super s
          end

          def values
            root.all(cell_selector).map { |n| node_text(n) }
          end

          private

          attr_accessor :cell_selector

          def node_text(node)
            NodeText.new(node)
          end
        end
      end
    end
  end
end
