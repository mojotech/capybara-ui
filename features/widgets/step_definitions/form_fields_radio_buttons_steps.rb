Then(/^we can change the value of the radio button to "(.*?)" with:$/) do |val, string|
  page_context.eval string

  expect(widget(:my_form).my_radio_button).to eq val
end

Then(/^we can get the text of the checked option with:$/) do |string|
  expect_code_with_result string
end

When(/^we try to change the value of the radio button to an invalid value:$/) do |string|
  @code = string
end

Then(/^we will see no radio button is selected:$/) do |string|
  expect_code_with_result string
end
