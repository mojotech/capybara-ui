Feature: .form macro

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
