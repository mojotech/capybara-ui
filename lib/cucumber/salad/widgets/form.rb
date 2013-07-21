module Cucumber
  module Salad
    module Widgets
      class Form < Widget
        def self.default_locator(type = nil, &block)
          alias_method :name_to_locator, type if type

          define_method :name_to_locator, &block if block
        end

        def self.check_box(name, label = nil)
          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            if val
              root.check l
            else
              root.uncheck l
            end
          end
        end

        def self.select(name, *args)
          opts   = args.extract_options!
          label, = args

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)
            w = opts.fetch(:writer) { ->(v) { v } }

            root.select w.(val).to_s, from: l
          end
        end

        def self.text_field(name, label = nil)
          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            root.fill_in l, with: val.to_s
          end
        end

        action :submit, '[type = submit]'

        def fill_all(attrs)
          attrs.each do |k, v|
            send "#{k}=", v
          end

          self
        end

        # Submit form with +attributes+.
        #
        # @param attrs [Hash] the form fields and their values
        #
        # @return the current widget
        def submit_with(attributes)
          fill_all attributes
          submit
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
