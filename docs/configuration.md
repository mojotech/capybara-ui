# Configuring Capybara-UI
Capybara-UI requires little configuration, but there is currently one behavior you may want to configure.

## Adding rescuable errors

Capybara-UI rescues all errors that subclass StandardError by default. However, some libraries have custom errors that subclass Exception. These errors will not be caught by `eventually`.

Add errors in the configuration file, e.g. `support/env.rb` for cucumber.

```ruby
Capybara::UI::Checkpoint.rescuable_errors << MyErrorThatSubclassesException
```
