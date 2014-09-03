Feature: Form Fields

  There are specific macros for each field type, but in this file we use the generic `field` macro, because this documentation applies to all field types.

  Background:
    Given the following HTML:
      """
      <form>
        <input type="text" name="named">
        <input type="submit">
      </form>
      """

  Scenario: Finding

    Fields are usually searched for using capybara's `find(:field, ...)`. It expects either the text of a label, an input name or an input id.

    Given the following widget definition:
      """
      class MyForm < Dill::Form
        field :text, 'named', Dill::TextField
      end
      """
    Then we can see the text field widget is present using:
      """
      widget(:my_form).widget?(:text) #=> true
      """
