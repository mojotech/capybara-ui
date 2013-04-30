module Cucumber
  module Salad
    class Table
      extend Forwardable

      include Enumerable
      include Conversions

      module Transformations
        def self.pass
          ->(val) { val }
        end
      end

      class Mapping
        def initialize(settings = {})
          self.key               = settings[:key]
          self.value_transformer = transformer(settings[:value_transformer], :pass)
        end

        def set(instance, row, key, value)
          row[transform_key(instance, key)] = transform_value(instance, value)
        end

        private

        attr_accessor :key, :value_transformer

        def transform_key(_, key)
          (self.key || key.squeeze(' ').strip.gsub(' ', '_')).to_sym
        end

        def transform_value(instance, value)
          instance.instance_exec(value, &value_transformer)
        end

        def transformer(set, fallback)
          set || Transformations.send(fallback)
        end
      end

      class << self
        def map(name, options = {}, &block)
          mappings[name] = Mapping.new(key: options[:to], value_transformer: block)
        end

        def mappings
          @mappings ||= with_parent_mappings
        end

        private

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

      private

      attr_accessor :table

      def default_mapper
        Mapping.new
      end

      def new_row(hash)
        hash.each_with_object({}) { |(k, v), h|
          mapping_for(k).set(self, h, k, v)
        }
      end

      def mapping_for(header)
        mappings[header] || default_mapper
      end
    end
  end
end
