module Cucumber
  module Salad
    module WidgetMacros
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
      def action(name, selector)
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
      def widget(name, selector, parent = Widgets::Widget, &block)
        type = Class.new(parent) {
          root selector

          instance_eval(&block) if block
        }

        const_set(Salad::WidgetName.new(name).to_sym, type)
      end
    end
  end
end
