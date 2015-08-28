Then(/^we will see the field (?:does not have|has) text with:$/) do |string|
  expect_code_with_result string
end
