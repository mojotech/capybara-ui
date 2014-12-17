Then(/^I should be able to convert the value to (?:.+) using:$/) do |string|
  page_context.eval_expectations string
end
