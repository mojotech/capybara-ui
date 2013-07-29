module Cucumber
  module Salad
    module Widgets
      class Widget
        extend Forwardable

        include WidgetContainer

        # @!group Widget macros

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
          def self.widget(name, selector, parent = Widgets::Widget, &block)
            type = Class.new(parent) {
              root selector
            }

            type.class_eval(&block) if block_given?

            const_set(Salad::WidgetName.new(name).to_sym, type)
          end

          # Creates a delegator for one sub-widget message.
          #
          # Since widgets are accessed through {WidgetContainer#widget}, we can't
          # use {Forwardable} to delegate messages to widgets.
          #
          # @param name the name of the receiver sub-widget
          # @param widget_message the name of the message to be sent to the sub-widget
          # @param method_name the name of the delegator. If +nil+ the method will
          #   have the same name as the message it will send.
          def self.widget_delegator(name, widget_message, method_name = nil)
            method_name = method_name || widget_message

            class_eval <<-RUBY
              def #{method_name}(*args)
                if args.size == 1
                  widget(:#{name}).#{widget_message} args.first
                else
                  widget(:#{name}).#{widget_message} *args
                end
              end
            RUBY
          end

        # @!endgroup

        # Determines if an instance of this widget class exists in
        # +parent_node+.
        #
        # @param parent_node [Capybara::Node] the node we want to search in
        #
        # @return +true+ if a widget instance is found, +false+ otherwise.
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

        # Determines if the widget underlying an action exists.
        #
        # @param name the name of the action
        #
        # @raise Missing if an action with +name+ can't be found.
        #
        # @return [Boolean] +true+ if the action widget is found, +false+
        #   otherwise.
        def has_action?(name)
          raise Missing, "couldn't find `#{name}' action" unless respond_to?(name)

          has_widget?(name)
        end

        def inspect
          xml = Nokogiri::HTML(page.body).at(root.path).to_xml

          "<!-- #{self.class.name}: -->\n" <<
           Nokogiri::XML(xml, &:noblanks).to_xhtml
        end

        class Reload < Capybara::ElementNotFound; end

        # Reloads the widget, waiting for its contents to change (by default),
        # or until +wait_time+ expires.
        #
        # Call this method to make sure a widget has enough time to update
        # itself.
        #
        # You can pass a block to this method to control what it means for the
        # widget to be reloaded.
        #
        # *Note: does not account for multiple changes to the widget yet.*
        #
        # @param wait_time [Numeric] how long we should wait for changes, in
        #   seconds.
        #
        # @yield A block that determines what it means for a widget to be
        #   reloaded.
        # @yieldreturn [Boolean] +true+ if the widget is considered to be
        #   reloaded, +false+ otherwise.
        #
        # @return the current widget
        def reload(wait_time = Capybara.default_wait_time, &test)
          unless test
            old_inspect = inspect
            test        = ->{ old_inspect != inspect }
          end

          root.synchronize(wait_time) do
            raise Reload unless test.()
          end

          self
        rescue Reload
          # raised on timeout

          self
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
