module Dill
  class Widget
    extend Forwardable

    include WidgetContainer

    class Removed < StandardError; end

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
      #   class PirateProfile < Dill::Widget
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
      def self.action(name, selector)
        wname = :"#{name}_widget"

        widget wname, selector

        define_method name do
          widget(wname).click

          self
        end
      end

      # Declares a new child widget.
      #
      # Child widgets are accessible inside the container widget using the
      # {#widget} message, or by sending a message +name+. They
      # are automatically scoped to the parent widget's root node.
      #
      # @example Defining a widget
      #   # Given the following HTML:
      #   #
      #   # <div id="root">
      #   #   <span id="child">Child</span>
      #   # </div>
      #   class Container < Dill::Widget
      #     root '#root'
      #
      #     widget :my_widget, '#child'
      #   end
      #
      #   container = widget(:container)
      #
      #   # accessing using #widget
      #   my_widget = container.widget(:my_widget)
      #
      #   # accessing using #my_widget
      #   my_widget = container.my_widget
      #
      # @overload widget(name, selector, type = Widget)
      #
      #   The most common form, it allows you to pass in a selector as well as a
      #   type for the child widget. The selector will override +type+'s
      #   root selector, if +type+ has one defined.
      #
      #   @param name the child widget's name.
      #   @param selector the child widget's selector.
      #   @param type the child widget's parent class.
      #
      # @overload widget(name, type)
      #
      #   This form allows you to omit +selector+ from the arguments. It will
      #   reuse +type+'s root selector.
      #
      #   @param name the child widget's name.
      #   @param type the child widget's parent class.
      #
      #   @raise ArgumentError if +type+ has no root selector defined.
      #
      # @yield A block allowing you to further customize the widget behavior.
      #
      # @see #widget
      def self.widget(name, *rest, &block)
        raise ArgumentError, "`#{name}' is a reserved name" \
          if WidgetContainer.instance_methods.include?(name.to_sym)

        case rest.first
        when Class
          arg_count = rest.size + 1
          raise ArgumentError, "wrong number of arguments (#{arg_count} for 2)" \
            unless arg_count == 2

          type = rest.first
          raise TypeError, "can't convert `#{type}' to Widget" \
            unless type.methods.include?(:selector)
          raise ArgumentError, "missing root selector for `#{type}'" \
            unless type.selector

          selector = type.selector
        when String
          arg_count = rest.size + 1

          case arg_count
          when 0, 1
            raise ArgumentError, "wrong number of arguments (#{arg_count} for 2)"
          when 2
            selector, type = [*rest, Widget]
          when 3
            selector, type = rest

            raise TypeError, "can't convert `#{type}' to Widget" \
              unless Class === type
          else
            raise ArgumentError, "wrong number of arguments (#{arg_count} for 3)"
          end
        else
          raise ArgumentError, "unknown method signature: #{rest.inspect}"
        end

        child = Class.new(type) { root selector }
        child.class_eval(&block) if block_given?

        const_set(Dill::WidgetName.new(name).to_sym, child)

        define_method name do
          widget(name)
        end
      end

      # Creates a delegator for one child widget message.
      #
      # Since widgets are accessed through {WidgetContainer#widget}, we can't
      # use {Forwardable} to delegate messages to widgets.
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
    def self.find_in(node, options = {})
      new(options.merge(root: node.find(selector)))
    end

    # Determines if an instance of this widget class exists in
    # +parent_node+.
    #
    # @param parent_node [Capybara::Node] the node we want to search in
    #
    # @return +true+ if a widget instance is found, +false+ otherwise.
    def self.present_in?(parent_node)
      parent_node.has_selector?(selector)
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

    # Compares the current widget with +value+, waiting for the comparison
    # to return +true+.
    def ==(value)
      checkpoint.wait_until(false) { cast_to(value) == value }
    end

    # Compares the current widget with +value+, waiting for the comparison
    # to return +false+.
    def !=(value)
      checkpoint.wait_until(false) { cast_to(value) != value }
    end

    def checkpoint(wait_time)
      Checkpoint.new(wait_time)
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

      has_widget?(:"#{name}_widget")
    end

    def inspect
      root = self.root

      xml = Nokogiri::HTML(page.body).at(root.path).to_xml

      "<!-- #{self.class.name}: -->\n" <<
       Nokogiri::XML(xml, &:noblanks).to_xhtml
    rescue Capybara::NotSupportedByDriverError
      root.inspect
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
    #
    # @see Checkpoint
    def reload(wait_time = Capybara.default_wait_time, &test)
      unless test
        old_root = root
        test     = ->{ old_root != root }
      end

      checkpoint(wait_time).wait_until(false, &test)

      begin
        root.inspect
      rescue
        raise Removed, "widget was removed"
      end

      self
    end

    # Calls +match+ on this widget's text content.
    #
    # If a block is given, passes the resulting match data to the block.
    #
    # @param pattern the pattern to match
    # @param position where to begin the search
    #
    # @yieldparam [MatchData] the match data from running +match+ on the text.
    #
    # @return [MatchData] the match data from running +match+ on the text.
    def match(pattern, position = 0, &block)
      checkpoint.wait_until(false) { to_s.match(pattern, position, &block) }
    end

    def to_i
      to_s.to_i
    end

    def to_f
      to_s.to_f
    end

    def to_s
      node_text(root)
    end

    alias_method :w, :widget

    protected

    def cast_to(value)
      case value
      when Float
        to_f
      when Integer
        to_i
      when String
        to_s
      else
        raise TypeError, "can't convert this widget to `#{klass}'"
      end
    end

    def node_text(node)
      NodeText.new(node)
    end

    private

    attr_writer :root

    def checkpoint(wait_time = Capybara.default_wait_time)
      Checkpoint.new(wait_time)
    end

    def page
      Capybara.current_session
    end
  end
end
