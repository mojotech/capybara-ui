module Capybara::UI
  # A select.
  class Select < Field
    def selected
      root.all(:xpath, ".//option", visible: true).select(&:selected?).first
    end

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
      selected.text unless selected.nil?
    end

    # @return [String] The value of the selected option.
    def value
      selected.value unless selected.nil?
    end

    # Selects the given +option+.
    #
    # You may pass in the option text or value.
    def set(option)
      widget(:option, option).select
    rescue
      begin
        widget(:option_by_value, option).select
      rescue Capybara::UI::MissingWidget => e
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
