module Dill
  # A point in time where some condition, or some set of conditions, should be
  # verified.
  #
  # @see http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Base#synchronize-instance_method,
  #   which inspired this class.
  class Checkpoint
    class ConditionNotMet < Capybara::ElementNotFound; end
    class TimeFrozen < StandardError; end

    # @return the configured wait time, in seconds.
    attr_reader :wait_time

    # @return the Capybara driver in use.
    def self.driver
      Capybara.current_session.driver
    end

    # Executes +block+ repeatedly until it returns a "truthy" value or +timeout+
    # expires.
    #
    # TODO: Expand documentation.
    def self.wait_for(wait_time = Capybara.default_wait_time, &block)
      new(wait_time).wait_for(&block)
    end

    # Initializes a new Checkpoint.
    #
    # @param wait_time how long this checkpoint will wait for its conditions to
    #   be met, in seconds.
    def initialize(wait_time = Capybara.default_wait_time)
      @wait_time = wait_time
    end

    # Waits until the condition encapsulated by the block is met.
    #
    # Automatically rescues some exceptions ({Capybara::ElementNotFound}, and
    # driver specific exceptions) until {wait_time} is exceeded. At that point
    # it raises whatever exception was raised in the condition block, or
    # {ConditionNotMet}, if no exception was raised inside the block. However,
    # if +raise_errors+ is set to +false+, returns +false+ instead of
    # propagating any of the automatically rescued exceptions.
    #
    # If an "unknown" exception is raised, it is propagated immediately, without
    # waiting for {wait_time} to expire.
    #
    # If a driver that doesn't support waiting is used, any exception raised is
    # immediately propagated.
    #
    # @param raise_errors [Boolean] whether to propagate exceptions that are
    #   "rescuable" when {wait_time} expires.
    #
    # @yield a block encapsulating the condition to be evaluated.
    # @yieldreturn a truthy value, if condition is met, a falsey value otherwise.
    #
    # @return whatever the condition block returns if the condition is
    #   successful.
    def wait_for(&condition)
      start

      begin
        yield or raise ConditionNotMet
      rescue *rescuable_errors
        raise if immediate?
        raise if expired?

        wait

        raise TimeFrozen, 'time appears to be frozen' if time_frozen?

        retry
      end
    end

    private

    attr_reader :start_time

    def driver
      self.class.driver
    end

    def driver_errors
      driver.invalid_element_errors
    end

    def expired?
      remaining_time > wait_time
    end

    def immediate?
      ! driver.wait?
    end

    def remaining_time
      Time.now - start_time
    end

    def rescuable_errors
      @rescuable_errors ||= [Capybara::ElementNotFound, *driver_errors]
    end

    def start
      @start_time = Time.now
    end

    def wait
      sleep 0.05
    end

    def time_frozen?
      Time.now == start_time
    end
  end
end
