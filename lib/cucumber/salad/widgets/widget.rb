module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include Salad::Conversions
        include WidgetContainer

        def self.action(name, selector, options = {})
          widget name, selector, type: options[:type] || Widget

          define_method name do
            widget(name).click
          end
        end

        def self.has_instance?(parent_node)
          parent_node.has_selector?(selector)
        end

        def self.in_node(node)
          new(root: node.find(selector))
        end

        def self.root(selector)
          @selector = selector

          define_method :default_root_selector do
            selector
          end

          private :default_root_selector
        end

        def self.selector
          @selector
        end

        def self.widget(name, selector, options = {}, &block)
          parent = options.fetch(:type, Widget)
          type   = Class.new(parent) {
            root selector

            instance_eval(&block) if block
          }

          const_set(Salad::WidgetName.new(name).to_sym, type)
        end

        def_delegators :root, :click

        def initialize(settings = {})
          self.root = settings[:root] if settings[:root]
        end

        def inspect
          xml = Nokogiri::HTML(page.body).at(root.path).to_xml

          "<!-- #{self.class.name}: -->\n" <<
           Nokogiri::XML(xml, &:noblanks).to_xhtml
        end

        def root
          @root || page.find(root_selector)
        end

        def to_s
          node_text(root)
        end

        def widget(name)
          widget_class(name).in_node(root)
        end

        alias_method :w, :widget

        protected

        def node_text(node)
          NodeText.new(node)
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
