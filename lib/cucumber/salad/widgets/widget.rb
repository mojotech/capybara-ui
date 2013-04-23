module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include Salad::Conversions

        def self.root(selector)
          define_method :default_root_selector do
            selector
          end

          private :default_root_selector
        end

        def self.widget(name, selector, type = Atom)
          define_method name do
            type.new(root: root.find(selector))
          end
        end

        def initialize(settings = {})
          self.root = settings[:root] if settings[:root]
        end

        def inspect
          xml = Nokogiri::HTML(page.body).at(root.path).to_xml

          "<!-- #{self.class.name}: -->\n" <<
           Nokogiri::XML(xml, &:noblanks).to_xhtml
        end

        private

        attr_writer :root_selector

        def default_root_selector
          raise NotImplementedError,
                "#{self.class.name}: default root selector undefined"
        end

        def page
          Capybara.current_session
        end

        def root
          @root || page.find(root_selector)
        end

        def root=(selector_or_node)
          case selector_or_node
          when String
            self.root_selector = selector_or_node
          when Capybara::Node::Element, Capybara::Node::Simple
            @root = selector_or_node
          else
            msg = "can't convert #{selector_or_node.inspect} to root node"

            raise ArgumentError, msg
          end
        end

        def root_selector
          @root_selector || default_root_selector
        end
      end
    end
  end
end
