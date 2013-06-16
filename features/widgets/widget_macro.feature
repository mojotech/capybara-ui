Feature: "widget" macro

  You can declare sub-widgets using the `widget` macro.

    widget <widget_name>, <selector>, <options>

  This creates a method <widget_name> on the parent widget, which, when called,
  returns a Widget instance.

  Background:
    Given the page /profile includes the following HTML:
      """
      <div>
        <span id="name">Guybrush Threepwood</span>
      </div>
      """

  @atom-widget
  Scenario: using "widget"
    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
      end
      """
    When I evaluate "PirateProfile.new.name"
    Then it should return the following:
      """
      <!-- Cucumber::Salad::Widgets::Atom: -->
      <span id="name">Guybrush Threepwood</span>
      """

  Scenario: using a different `widget` class
    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name', type: Cucumber::Salad::Widgets::Action
      end
      """
    When I evaluate "PirateProfile.new.name"
    Then it should return the following:
      """
      <!-- Cucumber::Salad::Widgets::Action: -->
      <span id="name">Guybrush Threepwood</span>
      """

  Scenario: testing whether a sub-widget exists

    If you want to test whether the parent widget contains a given sub-widget,
    you can't send the <widget_name> message to the parent widget, as that
    will raise an exception. Instead, you can send `has_<widget_name>?`.

    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
        widget :occupation, '#occupation'
      end
      """
    When I evaluate "PirateProfile.new.has_name?"
    Then it should return "true"
    When I evaluate "PirateProfile.new.has_occupation?"
    Then it should return "false"
    And the following should raise an exception:
      """
      PirateProfile.new.occupation
      """
