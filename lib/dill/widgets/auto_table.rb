module Dill
  class AutoTable < BaseTable

    # don't include footer in to_table, because footer column configuration is very
    # often different from the headers & values.
    def footers
      @footers ||= root.all(footer_selector).map { |n| Widget.new(n).text }
    end

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
      @headers ||= root.
                     all(header_selector).
        map { |n| Widget.new(n).text.downcase }
    end

    def footer_selector
      'tfoot td'
    end

    def values
      @values ||= data_rows.map(&:values)
    end

    class Row < Widget
      def initialize(settings)
        root = settings.delete(:root)

        self.cell_selector = settings.delete(:cell_selector)

        super root
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
