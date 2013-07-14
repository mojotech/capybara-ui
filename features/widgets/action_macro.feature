Feature: "action" macro

  Widget actions are declared using the `action` macro.

    action <name>, <selector>, <options>

  This creates a method `<name>` on the parent widget, which, when called, will
  click on that particular widget.

  TODO

  * Let an action point to the next widget, to ease chaining.

  Background:
    Given a page /entries/new includes the following HTML:
      """
      <span>Nice!</span>
      """
    And the current page /entries includes the following HTML:
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
    When I execute "widget(:pirate_journal).new_entry"
    Then I should be on "/entries/new"

  @has-widget
  Scenario: accessing the action widget

    You can access the underlying widget by calling `widget(<name>)`.

    When I evaluate "widget(:pirate_journal).widget(:new_entry)"
    Then it should return the following:
      """
      <!-- PirateJournal::NewEntry: -->
      <a href="/entries/new" rel="new-entry">New Entry</a>
      """
