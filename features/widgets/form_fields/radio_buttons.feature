Feature: Form Fields: Radio Button

  Background:
    Given the following HTML:
      """
      <form>
        <p class="number-container">
          <label>
            <input type="radio" id="1id" name="number" value="1" checked>Checked
          </label>
          <label>
            <input type="radio" id="2id" name="number" value="2">Unchecked
          </label>
          <label>
            <input type="radio" id="3id" name="number" value="3">Three
          </label>
        </p>
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Capybara::UI::Form
        radio_button :my_radio_button, '.number-container'
      end
      """

  Scenario: checked option
    Then we can get the text of the checked option with:
      """
      widget(:my_form).my_radio_button #=> "Checked"
      """

  Scenario: selecting an option
    Then we can change the value of the radio button to "Unchecked" with:
      """
      widget(:my_form).my_radio_button = "Unchecked"
      """

  Scenario: invalid option
    When we try to change the value of the radio button to an invalid value:
      """
      widget(:my_form).my_radio_button = "Four"
      """
    Then we will get the error Capybara::UI::InvalidRadioButton

  Scenario:
    Given the following HTML:
      """
      <form>
        <div class="number-container">
          <input type="radio" name="number" value="One">Unchecked One
          <input type="radio" name="number" value="Two">Unchecked Two
        </div>
      </form>
      """
    Then we will see no radio button is selected:
      """
      widget(:my_form).my_radio_button #=> nil
      """
