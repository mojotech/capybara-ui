Then(/^we can get the widget's (?:html id|css classes) with:$/) do |string|
  expect_code_with_result string
end

Then(/^we can check for the presence of a css class with:$/) do |string|
  expect_code_with_result string
end
