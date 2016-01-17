Feature: Form Fields: Select

  Background:
    Given the following HTML:
      """
      <form>
        <select name="number">
          <option value="1" selected>One</option>
          <option value="2">Two</option>
          <option value="3">Three</option>
        </select>
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Capybara::UI::Form
        select :my_select, 'number'
      end
      """

  Scenario: selected option
    Then we can get the text of the selected option with:
      """
      widget(:my_form).my_select #=> "One"
      """
    And we can get the value of the selected option with:
      """
      widget(:my_form).my_select_value #=> "1"
      """

  Scenario: selecting an option
    Then we can change the value of the select to "Two" with:
      """
      widget(:my_form).my_select = "Two"
      """
    And we can change the value of the select to "Three" with:
      """
      widget(:my_form).my_select = /Thr/
      """

  Scenario: invalid option
    When we try to change the value of the select to an invalid value:
      """
      widget(:my_form).my_select = "Four"
      """
    Then we will get the error Capybara::UI::InvalidOption

  Scenario:
    Given the following HTML:
      """
      <form>
        <select name="number">
          <option disabled="disabled">-- Escolha Um --</option>
          <option>Um</option>
          <option>Dois<option>
        </select>
      </form>
      """
    Then we will see no option is selected:
      """
      widget(:my_form).my_select #=> nil
      """
