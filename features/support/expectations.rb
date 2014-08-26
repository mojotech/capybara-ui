module Expectations
  class SimpleContext
    include Dill::DSL
    include RSpec::Matchers

    attr_reader :env

    def eval_expectation(code)
      setup, result = code.split('#=>').map(&:strip)

      expect(eval(setup)).to eq eval(result)
    end
  end

  class PageContext < SimpleContext
    attr_reader :page

    def initialize(page = "/test")
      @page = page

      load
    end

    public :eval

    private

    def load
      visit page

      self
    end
  end

  def page_context
    @context ||= PageContext.new
  end

  alias_method :load_page_context, :page_context

  def context
    @context ||= SimpleContext.new
  end

  def expect_code_with_result(string, evaluator = :eval_in_page)
    @context ||= evaluator == :eval_in_page ? page_context : context

    @context.eval_expectation string
  end
end

World Expectations
