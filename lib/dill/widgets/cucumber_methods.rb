module Dill
  module CucumberMethods
    begin
      require 'cucumber/ast/table'

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

      def easy_diff(table, wait_time = Capybara.default_max_wait_time)
        table = ArrayValue.new(table.raw).downcase_all
        table = new_cucumber_table(table)

        table.diff!(to_table.downcase_all) || true
      end

      private

      def new_cucumber_table(table)
        Cucumber::Ast::Table.new(table)
      end

    rescue LoadError
      # *crickets*
    end
  end
end
