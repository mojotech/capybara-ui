Feature: "widget" macro

  You can declare sub-widgets using the `widget` macro.

    widget <widget_name>, <selector>, <options>

  You can then access widgets using `widget(<widget_name>)`, or the slightly
  shorter `w(<widget_name)`.

  Background:
    Given the page /profile includes the following HTML:
      """
      <div>
        <span id="name">Guybrush Threepwood</span>
      </div>
      """

  Scenario: using "widget"
    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
      end
      """
    When I evaluate "PirateProfile.new.widget(:name)"
    Then it should return the following:
      """
      <!-- Cucumber::Salad::Widgets::Widget: -->
      <span id="name">Guybrush Threepwood</span>
      """

  Scenario: using a different `widget` class
    Given the following widgets:
      """
      class PirateName < Widget; end

      class PirateProfile < Widget
        widget :name, '#name', type: PirateName
      end
      """
    When I evaluate "PirateProfile.new.w(:name)"
    Then it should return the following:
      """
      <!-- PirateName: -->
      <span id="name">Guybrush Threepwood</span>
      """

  @has-widget
  Scenario: testing whether a sub-widget exists

    If you want to test whether the parent widget contains a given sub-widget,
    you can't send the widget(<widget_name>) message to the parent widget, as
    that will raise an exception. Instead, you can send
    `has_widget?(<widget_name>)`.

    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
        widget :occupation, '#occupation'
      end
      """
    When I evaluate "PirateProfile.new.has_widget?(:name)"
    Then it should return "true"
    When I evaluate "PirateProfile.new.has_widget?(:occupation)"
    Then it should return "false"
    And the following should raise an exception:
      """
      PirateProfile.new.widget(:occupation)
      """
