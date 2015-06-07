begin
  require 'rspec/matchers'

  RSpec::Matchers.define :see do |widget_name, *args|
    match do |role|
      begin
        eventually { role.see?(widget_name, *args) }
      rescue Dill::Checkpoint::ConditionNotMet
        false
      end
    end

    match_when_negated do |role|
      begin
        eventually { !role.see?(widget_name, *args) }
      rescue Dill::Checkpoint::ConditionNotMet
        false
      end
    end
  end
rescue LoadError
  # *crickets*
end
