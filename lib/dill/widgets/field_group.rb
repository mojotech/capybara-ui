module Dill
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
    #   class MyFieldGroup < Dill::FieldGroup
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
      field name, locator, CheckBox
    end

    # Defines a new field.
    #
    # @param name the name of the field accessor.
    # @param locator the field locator.
    # @param type the field class name.
    #
    # @api private
    def self.field(name, locator, type)
      raise TypeError, "can't convert `#{name}' to Symbol" \
        unless name.respond_to?(:to_sym)

      field_names << name.to_sym

      label     = name.to_s.gsub(/_/, ' ').capitalize
      locator ||= label

      widget name, locator, type do
        define_method :label do
          label
        end
      end

      define_method "#{name}=" do |val|
        widget(name).set val
      end

      define_method name do
        widget(name).get
      end
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
    #   class MyFieldGroup < Dill::FieldGroup
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
      field name, locator, Select
    end

    # Creates a new text field accessor.
    #
    # Adds the following methods to the widget:
    #
    # <name>:: Returns the current text field value, or +nil+ if no value
    #          has been set.
    # <name>=:: Sets the current text field value.
    # <name>? Returns +true+ if the current text field has content or
    #         +false+ otherwise
    #
    # @example
    #   # Given the following HTML:
    #   #
    #   # <form>
    #   #   <p>
    #   #     <label for="text-field">
    #   #     <input type="text" value="Content" id="text-field">
    #   #   </p>
    #   #   <p>
    #   #     <label for="empty-field">
    #   #     <input type="text" id="empty-field">
    #   #   </p>
    #   # </form>
    #   class MyFieldGroup < Dill::FieldGroup
    #     root 'form'
    #
    #     text_field :filled_field, 'text-field'
    #     text_field :empty_field, 'empty-field'
    #   end
    #
    #   form = widget(:my_field_group)
    #
    #   form.filled_field                #=> "Content"
    #   form.empty_field                 #=> nil
    #
    #   form.filled_field?                #=> true
    #   form.empty_field?                 #=> false
    #
    #   form.empty_field = "Not anymore"
    #   form.empty_field                 #=> "Not anymore"
    #
    # @param name the name of the text field accessor.
    # @param locator the locator for the text field. If +nil+ the locator
    #   will be derived from +name+.
    #
    # @todo Handle text field access when the field is disabled (raise an
    #   exception?)
    def self.text_field(name, locator = nil)
      define_method "#{name}?" do
        widget(name).content?
      end

      field name, locator, TextField
    end

    # @!endgroup

    # @return This field group's field widgets.
    def fields
      self.class.field_names.map { |name| widget(name) }
    end

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

    # Converts the current field group into a table suitable for diff'ing
    # with Cucumber::Ast::Table.
    #
    # Field labels are determined by the widget name.
    #
    # Field values correspond to the return value of each field's +to_s+.
    #
    # @return [Array<Array>] the table.
    def to_table
      headers = fields.map { |field| field.label.downcase }
      body    = fields.map { |field| field.to_s.downcase }

      [headers, body]
    end
  end
end
