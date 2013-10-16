module Dill
  # A form field.
  class Field < Widget
    def self.find_in(parent)
      new { parent.root.find_field(*selector) }
    end

    def self.present_in?(parent)
      parent.root.has_field?(*selector)
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
