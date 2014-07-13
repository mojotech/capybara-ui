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
