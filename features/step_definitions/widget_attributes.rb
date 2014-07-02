Then(/^we can get the widget's (?:html id|css classes) with:$/) do |string|
  code, result = string.split('#=>').map(&:strip)

  expect(eval_find(code)).to eq eval(result)
end
