Feature: .widget macro

  Generic widgets are usually declared inside roles using the `widget` macro.

  Scenario: Basic usage

    Given the following HTML:
      """
      <div id="inner">Inner!</div>
      """
    And the following role definition:
      """
      class Seer < Dill::Role
        widget :inner, "#inner"
      end
      """
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.widget?(:inner) #=> true
      """
