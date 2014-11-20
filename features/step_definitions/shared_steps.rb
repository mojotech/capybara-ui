Given(/^the following HTML(?: at the path "(.*?)")?:$/) do |*args|
  define_page_body(*args.reverse.compact)
end

Given(/^the following widget definition:$/) do |string|
  @widget_class = define_constant(string)
end

Then(/^we can see the widget is present using:$/) do |string|
  expect_code_with_result string
end
