require 'rspec/expectations'

Capybara::UI::Checkpoint.rescuable_errors << RSpec::Expectations::ExpectationNotMetError
