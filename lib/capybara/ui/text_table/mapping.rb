module Capybara
  module UI
    class TextTable
      class Mapping
        def initialize(settings = {})
          self.key               = settings[:key]
          self.value_transformer = transformer(settings[:value_transformer], :pass)
          self.key_transformer   = transformer(settings[:key_transformer], :keyword)
        end

        def set(instance, row, key, value)
          row[transform_key(instance, key)] = transform_value(instance, value)
        end

        private

        attr_accessor :key, :value_transformer, :key_transformer

        def transform_key(_, k)
          key || key_transformer.(k)
        end

        def transform_value(instance, value)
          instance.instance_exec(value, &value_transformer)
        end

        def transformer(set, fallback)
          case set
          when Symbol
            Transformations.send(set)
          when Proc
            set
          when nil
            Transformations.send(fallback)
          else
            raise ArgumentError, "can't convert #{set.inspect} to transformer"
          end
        end
      end
    end
  end
end
