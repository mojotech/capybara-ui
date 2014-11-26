Then(/^I should be able to convert the value to (?:.+) using:$/) do |string|
  expect_code_with_result string
end
