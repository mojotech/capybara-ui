module Dill
  # A Checkpoint that bypasses the standard wait time if the current
  # Capybara driver doesn't support waiting.
  class WidgetCheckpoint < Checkpoint
    # Returns the Capybara driver in use.
    def driver
      Capybara.current_session.driver
    end

    def initialize(*)
      if immediate?
        super 0
      else
        super
      end
    end

    protected

    def rescuable_errors
      @rescuable_errors ||= super + driver.invalid_element_errors
    end

    private

    def immediate?
      ! driver.wait?
    end
  end
end
