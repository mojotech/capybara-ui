def permitted_rspec_version?
  defined? RSpec && actual_rspec_expectations_version >= required_rspec_expectations_version
end

def actual_rspec_expectations_version
  defined? RSpec && Gem::Version.new(RSpec::Expectations::Version::STRING)
end

def required_rspec_expectations_version
  Gem::Version.new(Capybara::UI::OptionalDependencies::RSPEC_VERSION)
end

begin
  require 'rspec/matchers'
  require 'rspec/expectations/version'

  raise LoadError unless permitted_rspec_version?

  RSpec::Matchers.define :see do |widget_name, *args|
    match do |role|
      begin
        eventually { role.see?(widget_name, *args) }
      rescue Capybara::UI::Checkpoint::ConditionNotMet
        false
      end
    end

    failure_message do
      "Could not find widget(#{widget_name}, args.join(', ')) on page."
    end

    match_when_negated do |role|
      begin
        eventually { !role.see?(widget_name, *args) }
      rescue Capybara::UI::Checkpoint::ConditionNotMet
        false
      end
    end

    failure_message_when_negated do
      "Unexpectedly found widget(#{widget_name}, args.join(', ')) on page."
    end
  end

rescue LoadError
  "RSpec Expectations version #{required_rspec_expectations_version} or later is required. " \
  "You have #{actual_rspec_expectations_version}."
end
