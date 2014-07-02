Given(/^the following HTML:$/) do |string|
  define_page_body string
end

Given(/^the following widget definition:$/) do |string|
  @widget_class = define_widget(string)
end

Then(/^we can(?: also)? get an instance of the widget with:$/) do |string|
  expect(eval_find(string)).to be_instance_of @widget_class
end

Then(/^we can get an instance of the first "li" with:$/) do |string|
  expect(eval_find(string).text).to eq "One"
end

When(/^we get the widget with:$/) do |string|
  load_test_page

  @thread = Thread.new { eval(string) }
end

When(/^the widget's content changes to "(.*?)" before the timeout expires$/) do |string|
  Thread.new do
    sleep 0.75
    page.execute_script <<-JS
      document.getElementsByTagName('div')[0].textContent = #{string.inspect};
    JS
  end
end

Then(/^we will get an instance of the widget$/) do
  expect(@thread.value).to be_present
end

When(/^we try to find the widget with:$/) do |string|
  @code = string
end

Then(/^we will get the error Dill::(.+)$/) do |name|
  expect { eval_find(@code).root }.to raise_error Dill.const_get(name)
end
