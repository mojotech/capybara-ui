Feature: "action" macro

  Widget actions are declared using the `action` macro.

    action <name>, <selector>, <options>

  This creates a method `<name>` on the parent widget, which, when called, will
  click on that particular widget.

  TODO

  * Let an action point to the next widget, to ease chaining.

  Background:
    Given the page /entries includes the following HTML:
      """
      <div>
        <a href="/entries/new" rel="new-entry">New Entry</a>
      </div>
      """
    And the following widget:
      """
      class PirateJournal < Widget
        action :new_entry,  '[rel = new-entry]'
        action :edit_entry, '[rel = edit-entry]'
      end
      """

  Scenario: using `action`
    When I execute "PirateJournal.new.new_entry"
    Then I should be on "/entries/new"

  @has-widget
  Scenario: accessing the action widget

    You can access the underlying widget by calling `<name>_widget`.

    When I evaluate "PirateJournal.new.new_entry_widget"
    Then it should return the following:
      """
      <!-- Cucumber::Salad::Widgets::Action: -->
      <a href="/entries/new" rel="new-entry">New Entry</a>
      """
