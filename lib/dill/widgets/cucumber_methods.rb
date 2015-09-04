module Dill
  module CucumberMethods
    # Compares this widget with the given Cucumber +table+.
    #
    # === Example
    #
    #   Then(/^some step that takes in a cucumber table$/) do |table|
    #     widget(:my_widget).diff table
    #   end
    def diff(table, wait_time = Capybara.default_max_wait_time)
      table.diff!(to_table) || true
    end
  end
end
