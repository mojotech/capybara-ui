module Cucumber
  module Salad
    module Widgets
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
      end
    end
  end
end
