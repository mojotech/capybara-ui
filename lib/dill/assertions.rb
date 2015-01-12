module Dill
  module Assertions
    def assert_visible(role, widget_name, *args)
      eventually { role.see?(widget_name, *args) }
    rescue Dill::Checkpoint::ConditionNotMet
      false
    end

    def assert_not_visible(role, widget_name, *args)
      eventually { ! role.see?(widget_name, *args) }
    rescue Dill::Checkpoint::ConditionNotMet
      false
    end
  end
end
