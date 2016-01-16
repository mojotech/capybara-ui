@javascript
Feature: Actions

  An action is just a way to name an interaction with the UI.

  Currently, calling the action is the same as clicking the target widget. In the future we'll support other interaction types, like hovering.

  Calling an action returns the widget the action was defined on.

  Scenario: action on the current widget
    Given the following HTML:
      """
      <div id="torpedoes" onclick="this.innerHTML = 'Fired!'">Fire!</div>
      """
    And the following widget definition:
      """
      class Torpedoes < CapybaraUI::Widget
        root '#torpedoes'

        action :fire

        def fired?
          text == 'Fired!'
        end
      end
      """
    When we fire the torpedoes:
      """
      widget(:torpedoes).fire
      """
    Then we should see the torpedoes have been fired:
      """
      widget(:torpedoes).fired? #=> true
      """

  Scenario: action on a child widget
    Given the following HTML:
      """
      <div id="torpedoes">
        <span onclick="this.innerHTML = 'Fired!'">Fire!</span>
      </div>
      """
    And the following widget definition:
      """
      class Torpedoes < CapybaraUI::Widget
        root '#torpedoes'

        action :fire, 'span'

        def fired?
          widget(:fire_widget).text == 'Fired!'
        end
      end
      """
    When we fire the torpedoes:
      """
      widget(:torpedoes).fire
      """
    Then we should see the torpedoes have been fired:
      """
      widget(:torpedoes).fired? #=> true
      """
