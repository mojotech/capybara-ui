When(%r{^I visit "/somewhere" with:$}) do |string|
  eval string
end

Then(/^I should see the Here widget is present:$/) do |string|
  expect_code_with_result string, :eval
end
