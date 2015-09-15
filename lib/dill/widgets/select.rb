module Dill
  # A select.
  class Select < Field
    module Selectable
      def select
        root.select_option
      end
    end

    widget :option, -> (opt) {
      opt.is_a?(Regexp) ? ["option", text: opt] : [:option, opt]
    } do
      include Selectable
    end

    widget :option_by_value, -> (opt) { "option[value = #{opt.inspect}]" } do
      include Selectable
    end

    # @return [String] The text of the selected option.
    def get
      root.value
    end

    # Selects the given +option+.
    #
    # You may pass in the option text or value.
    def set(option)
      widget(:option, option).select
    rescue
      begin
        widget(:option_by_value, option).select
      rescue Dill::MissingWidget => e
        raise InvalidOption.new(e.message).
          tap { |x| x.set_backtrace e.backtrace }
      end
    end

    # @!method to_s
    #   @return the text of the selected option, or the empty string if
    #     no option is selected.
    def_delegator :get, :to_s

    def to_cell
      get
    end
  end
end
