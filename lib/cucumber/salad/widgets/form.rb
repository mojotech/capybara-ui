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

        def self.select_box(name, *args)
          opts   = args.extract_options!
          label, = args

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)
            w = opts.fetch(:writer) { ->(v) { v } }

            root.select w.(val).to_s, from: l
          end
        end

        def self.submit(attrs)
          new.fill_all(attrs).submit
        end

        def self.text(name, label = nil)
          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            root.fill_in l, with: val.to_s
          end
        end

        def initialize(settings = {})
          s    = settings.dup
          data = s.delete(:data) || {}

          super s

          fill_all data

          if block_given?
            yield self

            submit
          end
        end

        def fill_all(attrs)
          attrs.each do |k, v|
            send "#{k}=", v
          end

          self
        end

        def submit
          root.find('[type = "submit"]').click

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
