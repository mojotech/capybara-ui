module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include Salad::Conversions
        include WidgetContainer

        # Defines a new action.
        #
        # This is a shortcut to help defining a widget and a method that clicks
        # on that widget. You can then send a widget instance the message given
        # by +name+.
        #
        # @example
        #   # Consider the widget will encapsulate the following HTML
        #   #
        #   # <div id="profile">
        #   #  <a href="/profiles/1/edit" rel="edit">Edit</a>
        #   # </div>
        #   class PirateProfile < Salad::Widget
        #     root "#profile"
        #
        #     # Declare the action
        #     action :edit, '[rel = edit]'
        #   end
        #
        #   # Click the link
        #   widget(:pirate_profile).edit
        #
        # @param name the name of the action
        # @param selector the selector for the widget that will be clicked
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
