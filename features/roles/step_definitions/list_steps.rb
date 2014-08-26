Then(/^we should see that the list exists and contains 2 items:$/) do |string|
  page_context.eval_expectations string
end
