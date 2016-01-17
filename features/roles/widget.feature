Feature: .widget macro

  Generic widgets are usually declared inside roles using the `widget` macro.

  In every usage of `.widget`, you pass the widget name as the first argument. See below for the rest.

  Scenario: Basic usage

    Usually, you'll want to pass a CSS selector as the second argument.

    Given the following HTML:
      """
      <div id="inner">Inner!</div>
      """
    And the following role definition:
      """
      class Seer < Capybara::UI::Role
        widget :inner, "#inner"
      end
      """
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.visible?(:inner) #=> true
      """

  Scenario: With explicit class

    Pass a widget class as the 3rd argument to set the new widget class.

    Given the following HTML:
      """
      <ul>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
      </ul>
      """
    And the following role definition:
      """
      class WithClass < Capybara::UI::Role
        widget :list, "ul", Capybara::UI::List
      end
      """
    Then we should get a widget with the right class:
      """
      role = WithClass.new

      role.widget(:list).is_a?(Capybara::UI::List) #=> true
      """

  Scenario: With explicit class and default selector

    Pass a widget class as the 2nd argument to set the new widget class and use its default selector.

    Given the following HTML:
      """
      <ul>
        <li>One</li>
        <li>Two</li>
        <li>Three</li>
      </ul>
      """
    And the following role definition:
      """
      class WithDefaultSelector < Capybara::UI::Role
        widget :list, Capybara::UI::List
      end
      """
    Then we should get a widget with the right class:
      """
      role = WithDefaultSelector.new

      role.widget(:list).is_a?(Capybara::UI::List) #=> true
      """

  Scenario: With explicit class and missing default selector

    Given the following HTML:
      """
      <div id="a-div">A DIV!</div>
      """
    When we try to define the role:
      """
      class WithDefaultSelector < Capybara::UI::Role
        widget :div, Capybara::UI::Widget
      end
      """
    Then we should get a Capybara::UI::Widget::MissingSelector error

  Scenario: With a block

    Pass a block to `.widget` to customize the new widget's behavior.

    Given the following HTML:
      """
      <div id="number">2</div>
      """
    And the following role definition:
      """
      class WithBlock < Capybara::UI::Role
        widget :number, '#number' do
          def multiplied
            text.to_i * 2
          end
        end
      end
      """
    Then we should be able to use the widget as defined:
      """
      role = WithBlock.new

      role.widget(:number).multiplied #=> 4
      """

  Scenario: Widgets defined with .widget aren't visible outside the role

    Given the following HTML:
      """
      <div id="inner">Inner!</div>
      """
    And the following role definition:
      """
      class Seer < Capybara::UI::Role
        widget :inner, "#inner"
      end
      """
    When we try to access the widget outside the role:
      """
      widget(:inner)
      """
    Then we should get a Capybara::UI::Missing error
