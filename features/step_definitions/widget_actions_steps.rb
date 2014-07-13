When(/^we fire the torpedoes:$/) do |string|
  eval_in_page string
end

Then(/^we should see the torpedoes have been fired:$/) do |string|
  expect_code_with_result string, :eval
end
