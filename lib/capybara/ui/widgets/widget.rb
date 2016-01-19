module Capybara
  module UI
    class Widget
      extend Forwardable
      extend Widgets::DSL

      include WidgetParts::Struct
      include WidgetParts::Container
      include CucumberMethods

      class Removed < StandardError; end

      attr_reader :root

      # @!group Widget macros

      # Defines a new action.
      #
      # This is a shortcut to help defining a widget and a method that clicks
      # on that widget. You can then send a widget instance the message given
      # by +name+.
      #
      # You can access the underlying widget by appending "_widget" to the
      # action name.
      #
      # @example
      #   # Consider the widget will encapsulate the following HTML
      #   #
      #   # <div id="profile">
      #   #  <a href="/profiles/1/edit" rel="edit">Edit</a>
      #   # </div>
      #   class PirateProfile < Capybara::UI::Widget
      #     root "#profile"
      #
      #     # Declare the action
      #     action :edit, '[rel = edit]'
      #   end
      #
      #   pirate_profile = widget(:pirate_profile)
      #
      #   # Access the action widget
      #   action_widget = pirate_profile.widget(:edit_widget)
      #   action_widget = pirate_profile.edit_widget
      #
      #   # Click the link
      #   pirate_profile.edit
      #
      # @param name the name of the action
      # @param selector the selector for the widget that will be clicked
      def self.action(name, selector = nil)
        block = if selector
                  wname = :"#{name}_widget"

                  widget wname, selector

                  -> { widget(wname).click; self }
                else
                  -> { click; self }
                end

        define_method name, &block
      end

      # Creates a delegator for one child widget message.
      #
      # Since widgets are accessed through {WidgetParts::Container#widget}, we
      # can't use {Forwardable} to delegate messages to widgets.
      #
      # @param name the name of the receiver child widget
      # @param widget_message the name of the message to be sent to the child widget
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

      # Finds a single instance of the current widget in +node+.
      #
      # @param node the node we want to search in
      #
      # @return a new instance of the current widget class.
      #
      # @raise [Capybara::ElementNotFoundError] if the widget can't be found
      def self.find_in(parent, *args)
        new(filter.node(parent, *args))
      rescue Capybara::Ambiguous => e
        raise AmbiguousWidget.new(e.message).
          tap { |x| x.set_backtrace e.backtrace }
      rescue Capybara::ElementNotFound => e
        raise MissingWidget.new(e.message).
          tap { |x| x.set_backtrace e.backtrace }
      end

      def self.find_all_in(parent, *args)
        filter.nodes(parent, *args).map { |e| new(e) }
      end

      # Determines if an instance of this widget class exists in
      # +parent_node+.
      #
      # @param parent_node [Capybara::Node] the node we want to search in
      #
      # @return +true+ if a widget instance is found, +false+ otherwise.
      def self.present_in?(parent, *args)
        filter.node?(parent, *args)
      end

      def self.not_present_in?(parent, *args)
        filter.nodeless?(parent, *args)
      end

      # Sets this widget's default selector.
      #
      # You can pass more than one argument to it, or a single Array. Any valid
      # Capybara selector accepted by Capybara::Node::Finders#find will work.
      #
      # === Examples
      #
      # Most of the time, your selectors will be Strings:
      #
      #   class MyWidget < Capybara::UI::Widget
      #     root '.selector'
      #   end
      #
      # This will match any element with a class of "selector". For example:
      #
      #   <span class="selector">Pick me!</span>
      #
      # ==== Composite selectors
      #
      # If you're using CSS as the query language, it's useful to be able to use
      # +text: 'Some text'+ to zero in on a specific node:
      #
      #   class MySpecificWidget < Capybara::UI::Widget
      #     root '.selector', text: 'Pick me!'
      #   end
      #
      # This is especially useful, e.g., when you want to create a widget
      # to match a specific error or notification:
      #
      #   class NoFreeSpace < Capybara::UI::Widget
      #     root '.error', text: 'No free space left!'
      #   end
      #
      # So, given the following HTML:
      #
      #   <body>
      #     <div class="error">No free space left!</div>
      #
      #     <!-- ... -->
      #   </body>
      #
      # You can test for the error's present using the following code:
      #
      #   document.visible?(:no_free_space) #=> true
      #
      # Note: When you want to match text, consider using +I18n.t+ instead of
      # hard-coding the text, so that your tests don't break when the text changes.
      #
      # Finally, you may want to override the query language:
      #
      #   class MyWidgetUsesXPath < Capybara::UI::Widget
      #     root :xpath, '//some/node'
      #   end
      def self.root(*selector, &block)
        @filter = NodeFilter.new(block || selector)
      end

      class MissingSelector < StandardError
      end

      def self.filter
        @filter || superclass.filter
      rescue NoMethodError
        raise MissingSelector, 'no selector defined'
      end

      def self.filter?
        filter rescue false
      end

      def self.selector
        filter.selector
      end

      def initialize(root)
        @root = root
      end

      # Clicks the current widget, or the child widget given by +name+.
      #
      # === Usage
      #
      # Given the following widget definition:
      #
      #   class Container < Capybara::UI::Widget
      #     root '#container'
      #
      #     widget :link, 'a'
      #   end
      #
      # Send +click+ with no arguments to trigger a +click+ event on +#container+.
      #
      #   widget(:container).click
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container').click
      #
      # Send +click :link+ to trigger a +click+ event on +a+:
      #
      #   widget(:container).click :link
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container a').click
      def click(*args)
        if args.empty?
          root.click
        else
          widget(*args).click
        end
      end

      # Hovers over the current widget, or the child widget given by +name+.
      #
      # === Usage
      #
      # Given the following widget definition:
      #
      #   class Container < Capybara::UI::Widget
      #     root '#container'
      #
      #     widget :link, 'a'
      #   end
      #
      # Send +hover+ with no arguments to trigger a +hover+ event on +#container+.
      #
      #   widget(:container).hover
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container').hover
      #
      # Send +hover :link+ to trigger a +hover+ event on +a+:
      #
      #   widget(:container).hover :link
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container a').hover
      def hover(*args)
        if args.empty?
          root.hover
        else
          widget(*args).hover
        end
      end

      # Double clicks the current widget, or the child widget given by +name+.
      #
      # === Usage
      #
      # Given the following widget definition:
      #
      #   class Container < Capybara::UI::Widget
      #     root '#container'
      #
      #     widget :link, 'a'
      #   end
      #
      # Send +double_click+ with no arguments to trigger an +ondblclick+ event on +#container+.
      #
      #   widget(:container).double_click
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container').double_click
      def double_click(*args)
        if args.empty?
          root.double_click
        else
          widget(*args).double_click
        end
      end

      # Right clicks the current widget, or the child widget given by +name+.
      #
      # === Usage
      #
      # Given the following widget definition:
      #
      #   class Container < Capybara::UI::Widget
      #     root '#container'
      #
      #     widget :link, 'a'
      #   end
      #
      # Send +right_click+ with no arguments to trigger an +oncontextmenu+ event on +#container+.
      #
      #   widget(:container).right_click
      #
      # This is the equivalent of doing the following using Capybara:
      #
      #   find('#container').right_click
      def right_click(*args)
        if args.empty?
          root.right_click
        else
          widget(*args).right_click
        end
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

        visible?(:"#{name}_widget")
      end

      def id
        root['id']
      end

      def classes
        root['class'].split
      end

      # Determines if the widget has a specific class
      #
      # @param name the name of the class
      #
      # @return [Boolean] +true+ if the class is found, +false+ otherwise
      def class?(name)
        classes.include?(name)
      end

      def html
        xml = Nokogiri::HTML(page.body).at(root.path).to_xml

        Nokogiri::XML(xml, &:noblanks).to_xhtml.gsub("\n", "")
      end

      def text
        StringValue.new(root.text.strip)
      end

      # Converts this widget into a string representation suitable to be displayed
      # in a Cucumber table cell. By default calls #text.
      #
      # This method will be called by methods that build tables or rows (usually
      # #to_table or #to_row) so, in general, you won't call it directly, but feel
      # free to override it when needed.
      #
      # Returns a String.
      def to_cell
        text
      end

      def to_s
        text
      end

      def value
        text
      end

      private

      def page
        Capybara.current_session
      end
    end
  end
end
