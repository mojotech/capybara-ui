# CapybaraUI Helpers

##Table of Contents
  - [Cucumber helpers](#cucumber-helpers)

# Cucumber helpers
CapybaraUI currently provides a single method to work with Cucumber tables.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  # when the cucumber table values do not match the widget's values
  widget(:my_widget).diff table # raises error Cucumber::Ast::Table::Different

  # when the cucumber table values match the widget's values
  widget(:my_widget).diff table # => true
 end
```

Pass `ignore_case: true`, for a case-insensitive table match.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  widget(:my_widget).diff table, ignore_case: true
end
```
