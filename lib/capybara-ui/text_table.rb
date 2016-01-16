module CapybaraUI
  class TextTable
    extend Forwardable

    include Enumerable
    include Conversions

    class << self
      def Array(table)
        new(table).to_a
      end

      def Hash(table)
        new(table).to_h
      end

      def map(name, options = {}, &block)
        case name
        when :*
          set_default_mapping options, &block
        else
          set_mapping name, options, &block
        end
      end

      def mappings
        @mappings ||= Hash.
         new { |h, k| h[k] = Mapping.new }.
         merge(with_parent_mappings)
      end

      def skip(name)
        case name
        when :*
          set_default_mapping VoidMapping
        else
          raise ArgumentError, "can't convert #{name.inspect} to name"
        end
      end

      private

      def set_default_mapping(options, &block)
        case options
        when Hash
          @mappings = Hash.
           new { |h, k|
            h[k] = Mapping.new(key_transformer:   options[:to],
                               value_transformer: block) }.
           merge(mappings)
        when Class
          @mappings = Hash.new { |h, k| h[k] = options.new }.merge(mappings)
        else
          raise ArgumentError, "can't convert #{options.inspect} to mapping"
        end
      end

      def set_mapping(name, options, &block)
        mappings[name] = Mapping.
         new(key: options[:to], value_transformer: block)
      end

      def with_parent_mappings
        if superclass.respond_to?(:mappings)
          superclass.send(:mappings).dup
        else
          {}
        end
      end
    end

    def_delegators 'self.class', :mappings

    def initialize(table)
      self.table = table
    end

    def each(&block)
      rows.each(&block)
    end

    def rows
      @rows ||= table.hashes.map { |h| new_row(h) }
    end

    def single_row
      @single_row ||= new_row(table.rows_hash)
    end

    alias_method :to_a, :rows
    alias_method :to_h, :single_row

    private

    attr_accessor :table

    def new_row(hash)
      hash.each_with_object({}) { |(k, v), h|
        mapping_for(k).set(self, h, k, CellText.new(v))
      }
    end

    def mapping_for(header)
      mappings[header]
    end
  end
end
