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
      when String, Array
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
    def self.find_in(parent)
      new { parent.root.find(*selector) }
    end

    # Determines if an instance of this widget class exists in
    # +parent_node+.
    #
    # @param parent_node [Capybara::Node] the node we want to search in
    #
    # @return +true+ if a widget instance is found, +false+ otherwise.
    def self.present_in?(parent)
      parent.root.has_selector?(*selector)
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
    def self.root(*selector)
      @selector = selector.flatten
    end

    # Returns the selector specified with +root+.
    def self.selector
      @selector
    end

    def initialize(node = nil, &query)
      self.node = node
      self.query = query
    end

    # Returns +true+ if this widget's representation is less than +value+.
    #
    # Waits for the result to be +true+ for the time defined in
    # `Capybara.default_wait_time`.
    def <(value)
      test { self.value < value }
    end

    # Returns +true+ if this widget's representation is less than or equal to
    # +value+.
    #
    # Waits for the result to be +true+ for the time defined in
    # `Capybara.default_wait_time`.
    def <=(value)
      test { self.value <= value }
    end

    # Returns +true+ if this widget's representation is greater than +value+.
    #
    # Waits for the result to be +true+ for the time defined in
    # `Capybara.default_wait_time`.
    def >(value)
      test { self.value > value }
    end

    # Returns +true+ if this widget's representation is greater than or equal to
    # +value+.
    #
    # Waits for the result to be +true+ for the time defined in
    # `Capybara.default_wait_time`.
    def >=(value)
      test { self.value >= value }
    end

    # Compares the current widget with +value+, waiting for the comparison
    # to return +true+.
    def ==(value)
      test { self.value == value }
    end

    # Calls +=~+ on this widget's text content.
    def =~(regexp)
      test { to_s =~ regexp }
    end

    # Calls +!~+ on this widget's text content.
    def !~(regexp)
      test { to_s !~ regexp }
    end

    # Compares the current widget with +value+, waiting for the comparison
    # to return +false+.
    def !=(value)
      test { self.value != value }
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
    def click(name = nil)
      if name
        widget(name).click
      else
        root.click
      end
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
      # We use WidgetCheckpoint instead of #test because we want the
      # succeed-or-raise behavior.
      #
      # Unfortunately, Cucumber::Ast::Table#diff! changes its table, so that
      # #diff! can only be called once. For that reason, we need to create a
      # copy of the original table before we try to compare it.
      WidgetCheckpoint.wait_for(wait_time) {
        table.dup.diff!(to_table) || true
      }
    end

    # Returns +true+ if the widget is not visible, or has been removed from the
    # DOM.
    def gone?
      test { ! root rescue true }
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
    def reload(wait_time = Capybara.default_wait_time, &condition)
      unless condition
        old_root = root
        condition = ->{ old_root != root }
      end

      test wait_time, &condition

      self
    end

    # Returns +true+ if widget is visible.
    def present?
      test { !! root rescue false }
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
      test { to_s.match(pattern, position, &block) }
    end

    def root
      node || query.()
    end

    def text
      value.to_s
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
      value.to_s
    end

    def to_i
      value.to_i
    end

    def to_f
      value.to_f
    end

    def to_s
      value.to_s
    end

    def value
      NodeText.new(root)
    end

    private

    attr_accessor :node, :query

    def test(wait_time = Capybara.default_wait_time, &block)
      WidgetCheckpoint.wait_for(wait_time, &block)
    rescue Checkpoint::ConditionNotMet
      false
    end

    def page
      Capybara.current_session
    end
  end
end
