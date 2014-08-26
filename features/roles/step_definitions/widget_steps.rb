Then(/^we should get a widget with the right class:$/) do |string|
  expect_code_with_result string
end

Then(/^we should be able to use the widget as defined:$/) do |string|
  expect_code_with_result string
end

When(/^we try to access the widget outside the role:$/) do |string|
  begin
    page_context.eval(string)
  rescue Dill::Missing
    @rescued_dill_missing = true
  end
end

Then(/^we should get a Dill::Missing error$/) do
  expect(@rescued_dill_missing).to be true
end

When(/^we try to define the role:$/) do |string|
  begin
    page_context.eval string
  rescue Dill::Widget::MissingSelector
    @rescued_dill_missing_selector = true
  end
end

Then(/^we should get a Dill::Widget::MissingSelector error$/) do
  expect(@rescued_dill_missing_selector).to be true
end

Then(/^we should be able to use the "see_\*" method:$/) do |string|
  eval string
end

When(/^we try to find the unknown widget:$/) do |string|
  begin
    page_context.eval string
  rescue Dill::Missing
    @rescued_dill_missing = true
  end
end
