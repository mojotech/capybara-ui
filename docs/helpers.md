# Capybara-UI Helpers

##Table of Contents
  - [Generic helpers](#generic-helpers)
  - [RSpec helpers](#rspec-helpers)
  - [Cucumber helpers](#cucumber-helpers)

## Generic Helpers

#### #eventually
The `eventually` method re-runs the passed block until it either evaluates true or times out. Its timeout defaults to the `Capybara.default_max_wait_time`, but can also be specified as an argument in seconds.

```ruby
eventually { async_action == true } # loops for up to Capybara.default_max_wait_time
eventually(10) { async_action == true } # loops for up to 10 seconds
```


## RSpec helpers

#### see matcher
You can easily check for widgets in your RSpec steps by using the custom `see` matcher.

For a widget defined in the User role:

```ruby
class User < Capybara::UI::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] }
end
```

The role can expect `to see`, or `not_to see`, that widget.

```ruby
expect(User.new).to see :todo_item, 'Buy Milk'
```

You can `see` more complex logic by writing a method that begins with `see_` and ends with `?`:

```ruby
class User < Capybara::UI::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] }

  def see_custom_logic?(text)
    visible?(:todo_item, text) &&
    (1 + 1) == 2
  end
end
```

```ruby
expect(User.new).to see :custom_logic, 'my text'
```


## Cucumber helpers

#### widget#diff
`widget#diff` checks the table version of a widget against a cucumber AST table.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  # when the cucumber table values do not match the widget's values
  widget(:my_widget).diff(table) # raises error Cucumber::Ast::Table::Different

  # when the cucumber table values match the widget's values
  widget(:my_widget).diff(table) # => true
end
```

Pass `ignore_case: true`, for a case-insensitive table match.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  widget(:my_widget).diff(table, ignore_case: true)
end
```
