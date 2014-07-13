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
