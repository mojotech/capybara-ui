Feature: Values

  `widget(:widget_name).text` returns a String augmented with a few conversion methods, making it straightforward to perform a few common conversions.

  Scenario: List

    Splits a comma-separated string into its parts, and strips them of surrounding whitespace.

    Given the following HTML:
      """
      <div id="the-widget">a, b, c</div>
      """
    And the following widget definition:
      """
      class MyWidget < Capybara::UI::Widget
        root "#the-widget"
      end
      """
    Then I should be able to convert the value to a list of strings using:
      """
      widget(:my_widget).value.to_split #=> ['a', 'b', 'c']
      """

  Scenario: USD

    Converts a string that looks like a money sum in USD into a money instance.

    Given the following HTML:
      """
      <div id="the-widget">
        <span id="positive">$100,000,000.50</span>
        <span id="negative">-$100,000,000.50</span>
      </div>
      """
    And the following widget definition:
      """
      class MyWidget < Capybara::UI::Widget
        root "#the-widget"

        widget :positive, '#positive'
        widget :negative, '#negative'
      end
      """
    Then I should be able to convert the value to an integer using:
      """
      widget(:my_widget).widget(:positive).value.to_usd.to_i #=> 100000000
      widget(:my_widget).widget(:negative).value.to_usd.to_i #=> -100000000
      """
    And I should be able to convert the value to a float using:
      """
      widget(:my_widget).widget(:positive).value.to_usd.to_f #=> 100000000.5
      widget(:my_widget).widget(:negative).value.to_usd.to_f #=> -100000000.5
      """

  Scenario: Date from standard date format

    This works just like String#to_date.

    Given the following HTML:
      """
      <div id="the-widget">2014-11-26</div>
      """
    And the following widget definition:
      """
      class MyWidget < Capybara::UI::Widget
        root "#the-widget"
      end
      """
    Then I should be able to convert the value to a date using:
      """
      widget(:my_widget).value.to_date #=> Date.civil(2014, 11, 26)
      """

  Scenario: Date from custom date format

    Pass a date formate to convert a date in an unknown format to a string.

    Given the following HTML:
      """
      <div id="the-widget">11-2014-26</div>
      """
    And the following widget definition:
      """
      class MyWidget < Capybara::UI::Widget
        root "#the-widget"
      end
      """
    Then I should be able to convert the value to a date using:
      """
      widget(:my_widget).value.to_date('%m-%Y-%d') #=> Date.civil(2014, 11, 26)
      """

  Scenario: Key

    Replaces non-word characters (everything that is not a number, an underscore, or a letter) with an underscore, compresses the underscores and converts the string to lower case.

    Given the following HTML:
      """
      <div id="the-widget">A 12 Space-Separated ___ 'CamelCasedString'</div>
      """
    And the following widget definition:
      """
      class MyWidget < Capybara::UI::Widget
        root "#the-widget"
      end
      """
    Then I should be able to convert the value to a date using:
      """
      widget(:my_widget).value.to_key #=> :a_12_space_separated_camel_cased_string
      """
