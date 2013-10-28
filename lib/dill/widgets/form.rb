module Dill
  class Form < FieldGroup
    action :submit, '[type = submit]'

    # Submit form with +attributes+.
    #
    # @param attributes [Hash] the form fields and their values
    #
    # @return the current widget
    def submit_with(attributes)
      set attributes
      submit
    end

    def to_table
      info = self.
        class.
        field_names.
        each_with_object({}) { |e, a| a[e.to_s] = widget(e).to_cell }

      [info]
    end
  end
end
