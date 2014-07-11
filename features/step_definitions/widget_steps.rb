Given(/^the following HTML:$/) do |string|
  reset_server
  define_page_body string
end

Given(/^the following widget definition:$/) do |string|
  @widget_class = define_widget(string)
end
