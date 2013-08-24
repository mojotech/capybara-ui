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

    private

    def immediate?
      ! driver.wait?
    end
  end
end
