Feature: Form Fields: Text

  Background:
    Given the following HTML:
      """
      <form>
        <input id='user_name' type='text' value='Sheila'>
        <input id='password' type='text' value=''>
      </form>
      """
    And the following widget definition:
      """
      class MyForm < CapybaraUI::Form
        text_field :user_name, ['#user_name']
        text_field :password, ['#password']
      end
      """

  Scenario: boolean content checkers
    Then we will see the field has text with:
      """
      widget(:my_form).user_name? #=> true
      """

    Then we will see the field does not have text with:
      """
      widget(:my_form).password? #=> false
      """
