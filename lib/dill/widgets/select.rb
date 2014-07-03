module Dill
  # A select.
  class Select < Field
    # @return [String] The text of the selected option.
    def get
      option = root.find('[selected]') rescue nil

      option && option.text
    end

    # Selects the given +option+.
    #
    # You may pass in the option text or value.
    def set(option)
      root.find(:option, option).select_option
    rescue
      begin
        root.find("option[value = #{option.inspect}]").select_option
      rescue Capybara::ElementNotFound => e
        x = Dill::InvalidOption.new(e.message)
        x.set_backtrace e.backtrace

        raise x
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
