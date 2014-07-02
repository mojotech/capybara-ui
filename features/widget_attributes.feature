Feature: Widget Attributes

  Background:
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

  Scenario: html id
    Then we can get the widget's html id with:
      """
      widget(:my_widget).id #=> "the-widget"
      """

  Scenario: css classes
    Then we can get the widget's css classes with:
      """
      widget(:my_widget).classes #=> ["first", "second"]
      """
