module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable
        extend WidgetMacros

        include WidgetContainer

        def self.present_in?(parent_node)
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

        # @return The root node of the current widget
        attr_reader :root

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

        attr_writer :root

        def page
          Capybara.current_session
        end
      end
    end
  end
end
