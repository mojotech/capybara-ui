Feature: Widget

  Background:
    Given the page /entries includes the following HTML:
      """
      <div>
        <a href="/entries/new" rel="new-entry">New Entry</a>
      </div>
      """
    And the following widget:
      """
      class JournalEntryAction < Widget
        root 'a'
      end
      """

  Scenario: A widget is clickable
    When I execute "JournalEntryAction.new.click"
    Then I should be on "/entries/new"
