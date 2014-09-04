require 'rspec/matchers'

RSpec::Matchers.define :see do |widget_name, *args|
  match_for_should do |role|
    begin
      eventually { role.see?(widget_name, *args) }
    rescue Dill::Checkpoint::ConditionNotMet
      false
    end
  end

  match_for_should_not do |role|
    begin
      eventually { ! role.see?(widget_name, *args) }
    rescue Dill::Checkpoint::ConditionNotMet
      false
    end
  end
end
