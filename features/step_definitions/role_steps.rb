Given(/^the following role definition:$/) do |string|
  define_constant string
end

When(/^we ask the gardener to water the plants:$/) do |string|
  eval_in_page string
end

Then(/^we should see the plants have been watered:$/) do |string|
  expect_code_with_result string, :eval
end
