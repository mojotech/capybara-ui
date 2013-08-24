module Dill
  # A point in time where some condition, or some set of conditions, should be
  # verified.
  #
  # @see http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Base#synchronize-instance_method,
  #   which inspired this class.
  class Checkpoint
    class ConditionNotMet < StandardError; end
    class TimeFrozen < StandardError; end

    # @return the configured wait time, in seconds.
    attr_reader :wait_time

    # Shortcut for instance level wait_for.
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

    # Executes +block+ repeatedly until it returns a "truthy" value or
    # +wait_time+ expires.
    #
    # Swallows any StandardError or StandardError descendent until +wait_time+
    # expires. If an exception is raised and the time has expired, that
    # exception will be raised again.
    #
    # If the block does not return a "truthy" value until +wait_time+ expires,
    # raises a Dill::Checkpoint::ConditionNotMet error.
    #
    # Returns whatever value is returned by the block.
    def wait_for(&condition)
      start

      begin
        yield or raise ConditionNotMet
      rescue
        raise if expired?

        wait

        raise TimeFrozen, 'time appears to be frozen' if time_frozen?

        retry
      end
    end

    private

    attr_reader :start_time

    def expired?
      remaining_time > wait_time
    end

    def remaining_time
      Time.now - start_time
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
