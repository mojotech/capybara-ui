module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include Salad::Conversions
        include WidgetContainer

        def self.action(name, selector, parent = Widget)
          widget name, selector, parent

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
        end

        def self.selector
          @selector
        end

        def self.widget(name, selector, parent = Widget, &block)
          type = Class.new(parent) {
            root selector

            instance_eval(&block) if block
          }

          const_set(Salad::WidgetName.new(name).to_sym, type)
        end

        def_delegators :root, :click

        def initialize(settings = {})
          self.root = settings.fetch(:root)
        end

        def inspect
          xml = Nokogiri::HTML(page.body).at(root.path).to_xml

          "<!-- #{self.class.name}: -->\n" <<
           Nokogiri::XML(xml, &:noblanks).to_xhtml
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

        attr_accessor :root

        def page
          Capybara.current_session
        end
      end
    end
  end
end
