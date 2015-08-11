module Dill
  # A point in time where some condition, or some set of conditions, should be
  # verified.
  #
  # @see http://rubydoc.info/github/jnicklas/capybara/master/Capybara/Node/Base#synchronize-instance_method,
  #   which inspired this class.
  class Checkpoint
    class ConditionNotMet < StandardError; end

    class << self
      attr_accessor :rescuable_errors
    end

    self.rescuable_errors = [StandardError]

    if defined?(RSpec::Expectations)
      self.rescuable_errors << RSpec::Expectations::ExpectationNotMetError
    end

    class Timer
      class Frozen < StandardError; end

      def initialize(duration)
        @duration = duration
      end

      attr_reader :duration

      def expired?
        duration < elapsed
      end

      def elapsed
        now - start_time
      end

      def start
        @start_time = now
      end

      def tick
        sleep tick_duration

        raise Frozen, 'time appears to be frozen' if frozen?
      end

      protected

      def now
        Time.now
      end

      attr_reader :start_time

      def frozen?
        now == start_time
      end

      def tick_duration
        0.05
      end
    end

    # Shortcut for instance level wait_for.
    def self.wait_for(wait_time = Capybara.default_wait_time, &block)
      new(wait_time).call(&block)
    end

    # Initializes a new Checkpoint.
    #
    # @param wait_time how long this checkpoint will wait for its conditions to
    #   be met, in seconds.
    def initialize(wait_time = Capybara.default_wait_time)
      @timer = Timer.new(wait_time)
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
    def call(&condition)
      timer.start

      begin
        yield or raise ConditionNotMet
      rescue *rescuable_errors
        raise if timer.expired?

        timer.tick

        retry
      end
    end

    protected

    def rescuable_errors
      self.class.rescuable_errors
    end

    attr_reader :timer
  end
end
