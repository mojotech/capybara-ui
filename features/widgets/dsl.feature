Feature: DSL

  The Dill Widget DSL exposes a few methods to make it easier for you to work
  with widgets. When you include the module `Dill::DSL`, you get
  access to the following methods:

  * `widget(<name>)`
  * `has_widget?(<name>)`

  This module is automatically included for you when you're inside cucumber
  steps.

  Background:
    Given the page /profile includes the following HTML:
      """
      <div>
        <span id="name">Guybrush Threepwood</span>
      </div>
      """
    Given the following widget:
      """
      class Name < Widget
        root 'span'
      end
      """

  Scenario: Accessing top level widgets
    When I evaluate "widget(:name)"
    Then it should return the following:
      """
      <!-- Name: -->
      <span id="name">Guybrush Threepwood</span>
      """

  Scenario: Check whether a widget exists in the page
    Given the following widget:
      """
      class Back < Widget
        root 'a'
      end
      """
    Then "has_widget?(:name)" should return "true"
    And "has_widget?(:back)" should return "false"
