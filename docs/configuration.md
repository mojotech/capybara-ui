# Configuring CapybaraUI
CapybaraUI requires little configuration, but there is currently one behavior you may want to configure.

## Adding rescuable errors

CapybaraUI rescues all errors that subclass StandardError by default. However, some libraries have custom errors that subclass Exception. These errors will not be caught by `eventually`.

Add errors in the configuration file, e.g. `support/env.rb` for cucumber.

```ruby
CapybaraUI::Checkpoint.rescuable_errors << MyErrorThatSubclassesException
```
