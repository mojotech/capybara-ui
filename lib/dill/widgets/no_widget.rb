module Dill
  class NoWidget
    include WidgetParts::Presence

    def initialize(exception)
      @exception = exception
    end

    def inspect
      "#<DETACHED>"
    end

    def present?
      false
    end

    def method_missing(*args)
      wrapper_class = case @exception
                      when Capybara::Ambiguous
                        AmbiguousWidget
                      when Capybara::ElementNotFound
                        MissingWidget
                      else
                        raise "Unknown error: #{@exception.message}"
                      end

      raise wrapper_class.new(@exception.message).
        tap { |x| x.set_backtrace @exception.backtrace }
    end
  end
end
