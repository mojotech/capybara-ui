begin
  require 'rspec/matchers'
  require 'rspec/version'

  unless Gem::Version.new(RSpec::Version::STRING) >= Gem::Version.new(Capybara::UI::OptionalDependencies::RSPEC_VERSION)
    raise LoadError,
      "requires RSpec version #{Capybara::UI::OptionalDependencies::RSPEC_VERSION} or later. " \
      "You have #{RSpec::Version::STRING}."
  end

  RSpec::Matchers.define :see do |widget_name, *args|
    match do |role|
      begin
        eventually { role.see?(widget_name, *args) }
      rescue Capybara::UI::Checkpoint::ConditionNotMet
        false
      end
    end

    match_when_negated do |role|
      begin
        eventually { !role.see?(widget_name, *args) }
      rescue Capybara::UI::Checkpoint::ConditionNotMet
        false
      end
    end
  end
end
