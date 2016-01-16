module Expectations
  class SimpleContext
    include CapybaraUI::DSL
    include RSpec::Matchers

    attr_reader :env

    def eval_expectation(code, b = nil)
      setup, result = code.split('#=>').map(&:strip)

      expect(eval(*[setup, b].compact)).to eq eval(*[result, b].compact)
    end

    def eval_expectations(code)
      setup, result = code.split(/\n\n/)

      if result
        eval setup, canvas
      else
        result = setup
      end

      result.split("\n").each { |e| eval_expectation e, canvas }
    end

    def canvas
      @canvas ||= binding
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
