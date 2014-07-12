module Expectations
  def expect_code_with_result(string, evaluator = :eval_in_page)
    code, result = string.split('#=>').map(&:strip)

    expect(send(evaluator, code)).to eq eval(result)
  end
end

World Expectations
