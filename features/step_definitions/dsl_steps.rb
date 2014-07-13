When(%r{^I visit "/somewhere" with:$}) do |string|
  eval string
end

Then(/^I should see the Here widget is present:$/) do |string|
  expect_code_with_result string, :eval
end

When(/^I click the widget with:$/) do |string|
  eval_in_page string
end

Then(/^I should see the widget has been clicked with:$/) do |string|
  expect_code_with_result string, :eval
end
