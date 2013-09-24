module Dill
  module DynamicValue
    def self.new(checkpoint = Checkpoint, &block)
      DynamicValueInstance.new(checkpoint, &block)
    end

    def ==(other)
      delay { value == other }
    end

    def !=(other)
      delay { value != other }
    end

    def =~(other)
      delay { value =~ other }
    end

    def !~(other)
      delay { value !~ other }
    end

    def delay(wait_time = Capybara.default_wait_time, &block)
      checkpoint.wait_for(wait_time, &block)
    rescue ::Dill::Checkpoint::ConditionNotMet
      false
    end

    def inspect
      value.inspect
    end

    def method_missing(name, *args, &block)
      delay { value.__send__(name, *args, &block) }
    end

    def respond_to_missing?(*args)
      value.respond_to?(*args)
    end
  end

  class DynamicValueInstance
    include DynamicValue

    attr_reader :checkpoint

    def initialize(checkpoint = Checkpoint, &block)
      @checkpoint = checkpoint
      @block = block
    end

    def value
      @block.call
    end
  end
end
