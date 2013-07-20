module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include Salad::Conversions
        include WidgetContainer

        def self.action(name, selector)
          widget name, selector

          define_method name do
            widget(name).click

            self
          end
        end

        def self.has_instance?(parent_node)
          parent_node.has_selector?(selector)
        end

        # Finds a single instance of the current widget in +node+.
        #
        # @param node the node we want to search in
        #
        # @return a new instance of the current widget class.
        #
        # @raise [Capybara::ElementNotFoundError] if the widget can't be found
        def self.find_in(node, options = {})
          new(options.merge(root: node.find(selector)))
        end

        # Sets this widget's default selector.
        #
        # @param selector [String] a CSS or XPath query
        def self.root(selector)
          @selector = selector
        end

        # @return The selector specified with +root+.
        def self.selector
          @selector
        end

        # Declares a new sub-widget.
        #
        # Sub-widgets are accessible inside the container widget using the
        # +widget+ message.
        #
        # @param name the name of the sub-widget
        # @param selector the sub-widget selector
        # @param parent [Class] the parent class of the new sub-widget
        #
        # @yield A block allowing you to further customize the widget behavior.
        #
        # @see #widget
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
