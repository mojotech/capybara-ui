Feature: DSL

  Scenario: visiting a page
    Given the following HTML at the path "/somewhere":
      """
      <div id="here"></div>
      """
    And the following widget definition:
      """
      Here = Dill::Widget('#here')
      """
    When I visit "/somewhere" with:
      """
      visit "/somewhere"
      """
    Then I should see the Here widget is present:
      """
      widget(:here).present? #=> true
      """

  @javascript
  Scenario: clicking a widget
    Given the following HTML:
      """
      <div id="clickme" onclick="this.innerHTML = 'Clicked!'">Click Me!</a>
      """
    And the following widget definition:
      """
      Clicker = Dill::Widget('#clickme')
      """
    When I click the widget with:
      """
      click :clicker
      """
    Then I should see the widget has been clicked with:
      """
      widget(:clicker).text #=> "Clicked!"
      """

  @javascript
  Scenario: submitting a form with some fields set
    Given the following HTML:
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="text" name="first_name" />
        <input type="text" name="last_name" />
        <input type="submit">
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Dill::Form
        text_field :first_name, 'first_name'
        text_field :last_name, 'first_name'
      end
      """
    When I submit the form with:
      """
      submit :my_form, :first_name => 'Gubrush', :last_name => 'Threepwood'
      """
    Then I should see the form has been submitted:
      """
      widget(:my_form).text #=> "Submitted!"
      """

  @javascript
  Scenario: submitting a form with no fields set
    Given the following HTML:
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="submit">
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Dill::Form; end
      """
    When I submit the form with:
      """
      submit :my_form
      """
    Then I should see the form has been submitted:
      """
      widget(:my_form).text #=> "Submitted!"
      """

  @javascript
  Scenario: setting a form's values without submitting them
    Given the following HTML:
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="text" name="text_field">
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Dill::Form
        text_field :text_field, 'text_field'
      end
      """
    When we change the text field value:
      """
      set :my_form, :text_field => 'Value!'
      """
    Then we should see the text field value has been changed:
      """
      widget(:my_form).text_field #=> "Value!"
      """
    But the form shouldn't have been submitted:
      """
      widget(:my_form).text #=> ""
      """
