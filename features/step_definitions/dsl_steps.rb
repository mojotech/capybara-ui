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

When(/^I submit the form with:$/) do |string|
  eval_in_page string
end

Then(/^I should see the form has been submitted:$/) do |string|
  expect_code_with_result string, :eval
end

When(/^we change the text field value:$/) do |string|
  eval_in_page string
end

Then(/^we should see the text field value has been changed:$/) do |string|
  expect_code_with_result string, :eval
end

Then(/^the form shouldn't have been submitted:$/) do |string|
  expect_code_with_result string, :eval
end
