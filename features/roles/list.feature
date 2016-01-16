Feature: .list macro

  Although we can use the `widget` macro to declare a list, CapybaraUI provides a slightly more convenient way to do it, using the `list` macro.

  Scenario: Basic usage

    In its most common usage, we pass `list` 2 arguments: the widget name and a selector.

    Given the following HTML:
      """
      <ul id='the_list'>
        <li>One</li>
        <li>Two</li>
      </ul>
      """
    And the following role definition:
      """
      class Seer < CapybaraUI::Role
        list :the_list, '#the_list' do
          item 'li'
        end
      end
      """
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.visible?(:the_list) #=> true
      """

  Scenario: Using the default selector

    We can also pass the widget name only, and `list` will use CapybaraUI::List's default selector (`ul`) and item selector (`li`).

    Given the following HTML:
      """
      <ul id='the_list'>
        <li>One</li>
        <li>Two</li>
      </ul>
      """
    And the following role definition:
      """
      class Seer < CapybaraUI::Role
        list :the_list
      end
      """
    Then we should see that the list exists and contains 2 items:
      """
      seer = Seer.new

      seer.visible?(:the_list) #=> true
      seer.value(:the_list) #=> ['One', 'Two']
      """
