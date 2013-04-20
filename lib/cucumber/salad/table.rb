module Cucumber
  module Salad
    class Table
      extend Forwardable

      include Enumerable
      include Conversions

      class << self
        def header_mappings
          @header_mappings ||=
           with_parent_mappings(:header) { |h, k|
             h[k] = k.squeeze(' ').strip.gsub(' ', '_').to_sym
           }
        end

        def map(name, options = {}, &block)
          header_mappings[name.to_s] = options[:to].to_sym if options[:to]
          value_mappings[name.to_s]  = block if block_given?
        end

        def value_mappings
          @value_mappings ||=
           with_parent_mappings(:value) { |h, k|
             h[k] = ->(value) { value }
           }
        end

        private

        def with_parent_mappings(name, &init)
          m = "#{name}_mappings"

          if superclass.respond_to?(m)
            superclass.send(m).dup
          else
            Hash.new(&init)
          end
        end
      end

      def_delegators 'self.class', :header_mappings, :value_mappings

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

      def key_for(header)
        header_mappings[header]
      end

      def new_row(hash)
        hash.each_with_object({}) { |(k, v), h| h[key_for(k)] = value_for(k, v) }
      end

      def value_for(key, value)
        instance_exec(value, &value_mappings[key])
      end
    end
  end
end
