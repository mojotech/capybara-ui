module Dill
  class Widget
    extend Forwardable

    include DynamicValue

    include WidgetParts::Struct
    include WidgetParts::Container

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
    #   @param selector the child widget's selector. You can pass either a
    #     String or, if you want to use a composite selector, an Array.
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
        if WidgetParts::Container.instance_methods.include?(name.to_sym)

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
      when String, Array, Proc
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

      child = WidgetClass.new(selector, type, &block)

      const_set(Dill::WidgetName.new(name).to_sym, child)

      child
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
      new { parent.root.find(*selector(*args)) }
    end

    # Determines if an instance of this widget class exists in
    # +parent_node+.
    #
    # @param parent_node [Capybara::Node] the node we want to search in
    #
    # @return +true+ if a widget instance is found, +false+ otherwise.
    def self.present_in?(parent)
      find_in(parent).present?
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
    #   class MyWidget < Dill::Widget
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
    #   class MySpecificWidget < Dill::Widget
    #     root '.selector', text: 'Pick me!'
    #   end
    #
    # This is especially useful, e.g., when you want to create a widget
    # to match a specific error or notification:
    #
    #   class NoFreeSpace < Dill::Widget
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
    #   document.has_widget?(:no_free_space) #=> true
    #
    # Note: When you want to match text, consider using +I18n.t+ instead of
    # hard-coding the text, so that your tests don't break when the text changes.
    #
    # Finally, you may want to override the query language:
    #
    #   class MyWidgetUsesXPath < Dill::Widget
    #     root :xpath, '//some/node'
    #   end
    def self.root(*selector, &block)
      @selector = block ? [block] : selector.flatten
    end

    # Returns the selector specified with +root+.
    def self.selector(*args)
      if @selector
        fst = @selector.first

        fst.respond_to?(:call) ? fst.call(*args) : @selector
      else
        if superclass.respond_to?(:selector)
          superclass.selector
        else
          raise 'no selector defined'
        end
      end
    end

    def initialize(node = nil, &query)
      self.node = node
      self.query = query
    end

    # Alias for #gone?
    def absent?
      gone?
    end

    # Clicks the current widget, or the child widget given by +name+.
    #
    # === Usage
    #
    # Given the following widget definition:
    #
    #   class Container < Dill::Widget
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

    def dynamic(&block)
      DynamicValue.new(&block)
    end

    def dynamic_value
      dynamic { value }
    end

    # Compares this widget with the given Cucumber +table+.
    #
    # Waits +wait_time+ seconds for the comparison to be successful, otherwise
    # raises Cucumber::Ast::Table::Different on failure.
    #
    # This is especially useful when you're not sure if the widget is in the
    # proper state to be compared with the table.
    #
    # === Example
    #
    #   Then(/^some step that takes in a cucumber table$/) do |table|
    #     widget(:my_widget).diff table
    #   end
    def diff(table, wait_time = Capybara.default_wait_time)
      # #diff! raises an exception if the comparison fails, or returns nil if it
      # doesn't. We don't need to worry about failure, because that will be
      # propagated, but we need to return +true+ when it succeeds, to end the
      # comparison.
      #
      # Unfortunately, Cucumber::Ast::Table#diff! changes its table, so that
      # #diff! can only be called once. For that reason, we need to create a
      # copy of the original table before we try to compare it.
      delay(wait_time) { table.dup.diff!(to_table) || true }
    end

    # Returns +true+ if the widget is not visible, or has been removed from the
    # DOM.
    def gone?
      delay { ! root rescue true }
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
      inspection = "<!-- #{self.class.name}: -->\n"

      begin
        root = self.root
        xml = Nokogiri::HTML(page.body).at(root.path).to_xml

        inspection << Nokogiri::XML(xml, &:noblanks).to_xhtml
      rescue Capybara::NotSupportedByDriverError
        inspection << "<#{root.tag_name}>\n#{to_s}"
      rescue Capybara::ElementNotFound, *page.driver.invalid_element_errors
        "#<DETACHED>"
      end
    end

    # Returns +true+ if widget is visible.
    def present?
      delay { !! root rescue false }
    end

    def root
      node || query.()
    end

    def text
      root.text.strip
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

    attr_accessor :node, :query

    def checkpoint
      WidgetCheckpoint
    end

    def page
      Capybara.current_session
    end
  end
end
