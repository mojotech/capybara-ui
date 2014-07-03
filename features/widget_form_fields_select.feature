Feature: Widget Form Fields: Select

  Background:
    Given the following HTML:
      """
      <form>
        <select name="number">
          <option value="1" selected>One</option>
          <option value="2">
            Two
          </option>
        </select>
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Dill::Form
        root "form"

        select :my_select, 'number'
      end
      """

  Scenario: selected option
    Then we can get the text of the selected option with:
      """
      widget(:my_form).my_select #=> "One"
      """

  Scenario: selecting an option
    Then we can change the value of the select to "Two" with:
      """
      widget(:my_form).my_select = "Two"
      """

  Scenario: invalid option
    When we try to change the value of the select to an invalid value:
      """
      widget(:my_form).my_select = "Three"
      """
    Then we will get the error Dill::InvalidOption

  Scenario:
    Given the following HTML:
      """
      <form>
        <select name="number">
          <option>Um</option>
          <option>Dois<option>
        </select>
      </form>
      """
    Then we will see no option is selected:
      """
      widget(:my_form).my_select #=> nil
      """
