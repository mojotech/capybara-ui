module Cucumber
  module Salad
    module Widgets
      # A group of form fields.
      class FieldGroup < Widget
        root 'fieldset'

        def self.default_locator(type = nil, &block)
          alias_method :name_to_locator, type if type

          define_method :name_to_locator, &block if block
        end

        # The names of all the fields that belong to this field group.
        #
        # Field names are automatically added to this group as long as you use
        # the field definition macros.
        #
        # @return [Set] the field names.
        #
        # @see field
        def self.field_names
          @field_names ||= Set.new
        end

        # @!group Field definition macros

        def self.check_box(name, label = nil)
          field name

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            if val
              root.check l
            else
              root.uncheck l
            end
          end
        end

        # Defines a new field.
        #
        # For now, this is only used to add a name to {field_names}.
        #
        # @api private
        def self.field(name)
          raise TypeError, "can't convert `#{name}' to Symbol" \
            unless name.respond_to?(:to_sym)

          field_names << name.to_sym
        end

        def self.select(name, *args)
          field name

          opts   = args.last.is_a?(Hash) ? args.pop : {}
          label, = args

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)
            w = opts.fetch(:writer) { ->(v) { v } }

            root.select w.(val).to_s, from: l
          end
        end

        def self.text_field(name, label = nil)
          field name

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            root.fill_in l, with: val.to_s
          end
        end

        # @!endgroup

        # Sets the given form attributes.
        #
        # @param attributes [Hash] the attributes and values we want to set.
        #
        # @return the current widget.
        def set(attributes)
          attributes.each do |k, v|
            send "#{k}=", v
          end

          self
        end

        private

        def label(name)
          name.to_s.humanize
        end

        def name_to_locator(name)
          label(name)
        end
      end
    end
  end
end
