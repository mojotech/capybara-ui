Then(/^we can(?: also)? get an instance of the widget with:$/) do |string|
  expect(page_context.eval(string)).to be_instance_of @widget_class
end

Then(/^we can get an instance of the first "li" with:$/) do |string|
  expect(page_context.eval(string).text).to eq "One"
end

When(/^we try to get the widget with:$/) do |string|
  load_page_context

  sleep 0.75

  @thread = Thread.new { page_context.eval(string) }
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
  expect { page_context.eval(@code).root }.to raise_error Dill.const_get(name)
end
