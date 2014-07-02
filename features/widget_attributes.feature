Feature: Widget Attributes

  Scenario: getting the id
    Given the following HTML:
      """
      <div id="the-widget" class="first second">I'm a widget</div>
      """
    And the following widget definition:
      """
      class MyWidget < Dill::Widget
        root "#the-widget"
      end
      """
    Then we can get the widget's html id with:
      """
      widget(:my_widget).id #=> "the-widget"
      """
