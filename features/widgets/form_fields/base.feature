Feature: Form Fields

  There are specific macros for each field type, but in this file we use the generic `field` macro, because this documentation applies to all field types.

  Background:
    Given the following HTML:
      """
      <form>
        <input class="named-class" type="text" name="named">
        <input type="submit">
      </form>
      """

  Scenario: Finding

    Fields are usually searched for using capybara's `find(:field, ...)`. It expects either the text of a label, an input name or an input id.

    Given the following widget definition:
      """
      class MyForm < CapybaraUI::Form
        field :text, 'named', CapybaraUI::TextField
      end
      """
    Then we can see the text field widget is present using:
      """
      widget(:my_form).visible?(:text) #=> true
      """

  Scenario: Overriding the :field selector

    Sometimes you may want to skip the usage of `find(:field, ...)` and pass a bare-bones selector instead. You can do it by enclosing the selector in an array.

    Given the following widget definition:
      """
      class MyForm < CapybaraUI::Form
        field :text, ['.named-class'], CapybaraUI::TextField
      end
      """
    Then we can see the text field widget is present using:
      """
      widget(:my_form).visible?(:text) #=> true
      """
