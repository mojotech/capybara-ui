Feature: DSL

  The Salad Widget DSL exposes a few methods to make it easier for you to work
  with widgets. When you include the module `Cucumber::Salad::DSL`, you get
  access to the `widget(<name>)` method.

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

  Scenario: Unknown widgets
    Then "widget(:unknown)" should raise "UnknownWidgetError":
