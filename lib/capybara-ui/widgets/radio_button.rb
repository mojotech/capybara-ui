module CapybaraUI
  # A radio button.
  class RadioButton < Field
    widget :checked, -> {
      case Capybara.current_driver
      when :rack_test
        ['[checked]']
      else
        ['input:checked']
      end
    }
    widget :checked_label_by_value, -> (val) { [:xpath, ".//label[input[@type='radio' and @value='#{val}']]"] }
    widget :checked_label_by_id, -> (id) { [:xpath, ".//label[@for='#{id}']"] }
    widget :button_by_value, -> (val) { "[value='#{val}']" }

    def self.root(selector)
      super(["#{selector}"])
    end

    # @return [String] The text of the checked button's label.
    def get
      if visible?(:checked_label_by_value, value)
        widget(:checked_label_by_value, value).text
      elsif visible?(:checked_label_by_id, id)
        widget(:checked_label_by_id, id).text
      else
        nil
      end
    end

    # @return [String] The value of the checked button.
    def value
      visible?(:checked) ? widget(:checked).root.value : nil
    end

    # @return [String] The id of the checked button.
    def id
      visible?(:checked) ? widget(:checked).id : nil
    end

    # First attempts to choose the button by id or label text
    # Then attempts to choose the button by value
    def set(str)
      root.choose(str)
    rescue
      begin
        widget(:button_by_value, str).root.set(true)
      rescue CapybaraUI::MissingWidget => e
        raise InvalidRadioButton.new(e.message).
          tap { |x| x.set_backtrace e.backtrace }
      end
    end

    # @return the text of the checked button, or an empty string if
    # no button is checked.
    def_delegator :get, :to_s

    def to_cell
      get
    end
  end
end
