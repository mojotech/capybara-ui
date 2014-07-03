module Expectations
  def expect_code_with_result(string)
    code, result = string.split('#=>').map(&:strip)

    expect(eval_in_page(code)).to eq eval(result)
  end
end

World Expectations
