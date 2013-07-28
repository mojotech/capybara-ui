module Cucumber
  module Salad
    module Widgets
      # A group of form fields.
      #
      # @todo Explain how to use locators when defining fields, including what
      #   happens when locators are omitted.
      class FieldGroup < Widget
        root 'fieldset'

        def self.default_locator(type = nil, &block)
          alias_method :name_to_locator, type if type

          define_method :name_to_locator, &block if block
        end

        # The names of all the fields that belong to this field group.
        #
        # Field names are automatically added to this group as long as you use
        # the field definition macros.
        #
        # @return [Set] the field names.
        #
        # @see field
        def self.field_names
          @field_names ||= Set.new
        end

        # @!group Field definition macros

        # Creates a new checkbox accessor.
        #
        # Adds the following methods to the widget:
        #
        # <name>:: Gets the current checkbox state, as a boolean. Returns +true+
        #          if the corresponding check box is checked, +false+ otherwise.
        # <name>=:: Sets the current checkbox state. Pass +true+ to check the
        #           checkbox, +false+ otherwise.
        #
        # @example
        #   # Given the following HTML:
        #   #
        #   # <form>
        #   #   <p>
        #   #     <label for="checked-box">
        #   #     <input type="checkbox" value="1" id="checked-box" checked>
        #   #   </p>
        #   #   <p>
        #   #     <label for="unchecked-box">
        #   #     <input type="checkbox" value="1" id="unchecked-box">
        #   #   </p>
        #   # </form>
        #   class MyFieldGroup < Cucumber::Salad::Widgets::FieldGroup
        #     root 'form'
        #
        #     check_box :checked_box, 'checked-box'
        #     check_box :unchecked_box, 'unchecked-box'
        #   end
        #
        #   form = widget(:my_field_group)
        #
        #   form.checked_box          #=> true
        #   form.unchecked_box        #=> false
        #
        #   form.unchecked_box = true
        #   form.unchecked_box        #=> true
        #
        # @param name the name of the checkbox accessor.
        # @param locator the locator for the checkbox. If +nil+ the locator will
        #   be derived from +name+.
        #
        # @todo Handle checkbox access when the field is disabled (raise an
        #   exception?)
        def self.check_box(name, locator = nil)
          field name

          define_method "#{name}=" do |val|
            l = locator || name_to_locator(name)

            if val
              root.check l
            else
              root.uncheck l
            end
          end

          define_method name do
            l = locator || name_to_locator(name)

            !! root.find_field(l).checked?
          end
        end

        # Defines a new field.
        #
        # For now, this is only used to add a name to {field_names}.
        #
        # @api private
        def self.field(name)
          raise TypeError, "can't convert `#{name}' to Symbol" \
            unless name.respond_to?(:to_sym)

          field_names << name.to_sym
        end

        # Creates a new select accessor.
        #
        # Adds the following methods to the widget:
        #
        # <name>:: Gets the current selected option. Returns the label of the
        #          selected option, or +nil+, if no option is selected.
        # <name>=:: Selects an option on the current select. Pass the label of
        #           the option you want to select.
        #
        # @example
        #   # Given the following HTML:
        #   #
        #   # <form>
        #   #   <p>
        #   #     <label for="selected">
        #   #     <select id="selected">
        #   #       <option selected>Selected option</option>
        #   #       <option>Another option</option>
        #   #     </select>
        #   #   </p>
        #   #   <p>
        #   #     <label for="deselected">
        #   #     <select id="deselected">
        #   #       <option>Deselected option</option>
        #   #       <option>Another option</option>
        #   #     </select>
        #   #   </p>
        #   # </form>
        #   class MyFieldGroup < Cucumber::Salad::Widgets::FieldGroup
        #     root 'form'
        #
        #     select :selected, 'selected'
        #     select :deselected, 'deselected'
        #   end
        #
        #   form = widget(:my_field_group)
        #
        #   form.selected                         #=> "Selected option"
        #   form.deselected                       #=> nil
        #
        #   form.deselected = "Deselected option"
        #   form.unchecked_box                    #=> "Deselected option"
        #
        # @param name the name of the select accessor.
        # @param locator the locator for the select. If +nil+ the locator will
        #   be derived from +name+.
        #
        # @todo Handle select access when the field is disabled (raise an
        #   exception?)
        # @todo Raise an exception when an option doesn't exist.
        # @todo Allow passing the option value to set an option.
        # @todo Ensure an option with no text returns the empty string.
        # @todo What to do when +nil+ is passed to the writer?
        def self.select(name, locator = nil)
          field name

          define_method "#{name}=" do |val|
            l = locator || name_to_locator(name)

            root.select val.to_s, from: l
          end

          define_method name do
            l = locator || name_to_locator(name)

            option = root.find_field(l).first('[selected]') and option.text
          end
        end

        def self.text_field(name, label = nil)
          field name

          define_method "#{name}=" do |val|
            l = label || name_to_locator(name)

            root.fill_in l, with: val.to_s
          end

          define_method name do
            l = label || name_to_locator(name)

            root.find_field(l).value
          end
        end

        # @!endgroup

        # Sets the given form attributes.
        #
        # @param attributes [Hash] the attributes and values we want to set.
        #
        # @return the current widget.
        def set(attributes)
          attributes.each do |k, v|
            send "#{k}=", v
          end

          self
        end

        private

        def label(name)
          name.to_s.humanize
        end

        def name_to_locator(name)
          label(name)
        end
      end
    end
  end
end
