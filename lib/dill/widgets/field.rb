module Dill
  # A form field.
  class Field < Widget
    def self.root(selector)
      super String === selector ? [:field, selector] : selector
    end

    # @return This field's value.
    #
    # Override this to get the actual value.
    def get
      raise NotImplementedError
    end

    # Sets the field value.
    #
    # Override this to set the value.
    def set(value)
      raise NotImplementedError
    end
  end
end
