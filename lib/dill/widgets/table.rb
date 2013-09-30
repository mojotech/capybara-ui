module Dill
  class Table < BaseTable
    class ColumnDefinition
      attr_reader :header

      def initialize(selector, header, transform)
        self.selector  = selector
        self.header    = header
        self.transform = transform
      end

      def ensure_loaded(container)
        container.find(selector)
      rescue Capybara::Ambiguous
      end

      def values(container)
        container.all(selector).map { |n| transform.(node_text(n)).to_s }
      end

      private

      attr_accessor :selector
      attr_writer :header, :transform

      def node_text(node)
        NodeText.new(node)
      end

      def transform
        @transform ||= ->(v) { v }
      end
    end

    class << self
      attr_accessor :column_selector, :header_selector
    end

    def self.column(selector, header = nil, &transform)
      column_definitions << ColumnDefinition.new(selector, header, transform)
    end

    def self.column_definitions
      @column_definitions ||= []
    end

    protected

    def ensure_table_loaded
      column_definitions.first.ensure_loaded(self)
    end

    private

    def_delegators 'self.class', :column_selector, :column_definitions,
                                 :header_selector

    def headers
      @headers ||= column_definitions.map(&:header)
    end

    def values
      @values ||= column_definitions.map { |d| d.values(root) }.transpose
    end
  end
end
