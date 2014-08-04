Feature: Macros

  Scenario: declaring a role-specific widget

    Widgets can be declared in roles in the usual ways. An especially handy one is the same .widget macro that is used to declare widgets inside other widgets.

    Given the following HTML:
      """
      <div id="seen-outer">Seen Outer!</div>
      <div id="seen-inner">Seen Inner!</div>
      """
    And the following widget definition:
      """
      SeenOuter = Dill::Widget('#seen-outer')
      """
    And the following role definition:
      """
      class Seer < Dill::Role
        widget :seen_inner, "#seen-inner"
      end
      """
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.widget?(:seen_inner) #=> true
      """

  Scenario: declaring a role-specific form

    Although we can use the `widget` macro to declare a form, Dill provides a slightly more convenient way to do it, using the `form` macro.

    Given the following HTML:
      """
      <form id='the_form'>
        <input name='the_text_field'>
      </form>
      """
    And the following role definition:
      """
      class Seer < Dill::Role
        form :the_form, '#the_form' do
          text_field :the_text_field, 'the_text_field'
        end
      end
      """
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.widget?(:the_form) #=> true
      """
