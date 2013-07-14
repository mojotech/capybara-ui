Given(/^the page (.+) includes the following HTML:$/) do |path, body|
  SaladApp.class_eval do
    get path do
      <<-HTML
      <html>
      <body>
        #{body}
      </body>
      </html>
      HTML
    end
  end

  visit path
end

Given(/^the following widgets?:$/) do |code|
  step 'I execute the following code:', code
end

When(/^I execute the following code:$/) do |code|
  eval code
end

When(/^I execute "(.*?)"$/) do |code|
  step "I execute the following code:", code
end

When(/^I evaluate the following code:$/) do |code|
  @retval = eval(code)
end

When(/^I evaluate "([^"]+)"$/) do |code|
  @retval = eval(code)
end

Then(/^it should return the following:$/) do |retval|
  expect(@retval.inspect.strip).to eq retval.strip
end

Then(/^it should return "([^"]+)"$/) do |retval|
  step "it should return the following:", retval
end

Then(/^the following should raise an exception:$/) do |code|
  expect { eval code }.to raise_error
end

Then(/^"(.*?)" should raise "(.*?)":$/) do |code, exception_name|
  expect { eval code }.to raise_error(Cucumber::Salad.const_get(exception_name))
end

Then(/^I should be on "(.*?)"$/) do |path|
  expect(URI.parse(page.current_url).path).to eq path
end
