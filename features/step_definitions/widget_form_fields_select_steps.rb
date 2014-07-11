Then(/^we can change the value of the select to "(.*?)" with:$/) do |val, string|
  eval_in_page(string)

  expect(widget(:my_form).my_select).to eq val
end

Then(/^we can get the text of the selected option with:$/) do |string|
  expect_code_with_result string
end

When(/^we try to change the value of the select to an invalid value:$/) do |string|
  @code = string
end

Then(/^we will see no option is selected:$/) do |string|
  expect_code_with_result string
end
