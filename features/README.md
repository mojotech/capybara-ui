Capybara-UI comprises a set of helpers designed to help you write "literate tests" (tests written as living documentation).

Currently, Capybara-UI's main focus is end-to-end testing, but we certainly don't intend to stop here. Watch this space.

## Requirements

* Cucumber 1.3 or later
* Rails 3.2 or later

## Installation

Once you have Cucumber setup in your Rails project, add the following to `features/support/env.rb`, or some other file:

```
require 'capybara/ui/cucumber'
```
