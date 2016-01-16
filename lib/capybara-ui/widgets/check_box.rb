module CapybaraUI
  # A check box.
  class CheckBox < Field
    # @!method set(value)
    #   Checks or unchecks the current checkbox.
    #
    #   @param value [Boolean] +true+ to check the checkbox, +false+
    #     otherwise.
    def_delegator :root, :set

    # @return [Boolean] +true+ if the checkbox is checked, +false+
    #   otherwise.
    def get
      !! root.checked?
    end

    def to_cell
      to_s
    end

    # @return +"yes"+ if the checkbox is checked, +"no"+ otherwise.
    def to_s
      get ? 'yes' : 'no'
    end
  end
end
