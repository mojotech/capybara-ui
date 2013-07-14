Feature: Sub-widgets

  You declare sub-widgets by declaring inner widget classes. The inner class's
  root selector will be considered relative to the node of the parent widget
  class.

  You can also declare sub-widgets using the `widget` macro.

    widget <widget_name>, <selector>, <type>

  Sub-widgets will be accessible using `widget(<widget_name>)`, or the slightly
  shorter `w(<widget_name)`.

  Background:
    Given the page /profile includes the following HTML:
      """
      <section class="pirate-profile">
        <span class="name">Ghost Pirate LeChuck</span>
      </section>

      <div>
        <span class="name" id="name">Guybrush Threepwood</span>
        <span id="favorite_drink">Grog</span>

        <section id="love-interest" class="pirate-profile">
          <span class="name">Elaine Marley</span>
        </section>
      </div>
      """

  Scenario: using "widget"
    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
      end
      """
    When I evaluate "widget(:pirate_profile).widget(:name)"
    Then it should return the following:
      """
      <!-- PirateProfile::Name: -->
      <span class="name" id="name">Guybrush Threepwood</span>
      """

  Scenario: using a different `widget` class
    Given the following widgets:
      """
      class PirateDrink < Widget
        def inspect
          "<!-- #{self.class.superclass.name}: -->\n#{super}"
        end
      end

      class PirateProfile < Widget
        widget :drink, '#favorite_drink', PirateDrink
      end
      """
    When I evaluate "widget(:pirate_profile).widget(:drink)"
    Then it should return the following:
      """
      <!-- PirateDrink: -->
      <!-- PirateProfile::Drink: -->
      <span id="favorite_drink">Grog</span>
      """

  Scenario: keeping sub-widgets to the parent widget scope
    Given the following widget:
      """
      class PirateProfile < Widget
        class LoveInterest < Widget
          root '.pirate-profile'
        end
      end
      """
    When I evaluate "widget(:pirate_profile).widget(:love_interest)"
    Then it should return the following:
      """
      <!-- PirateProfile::LoveInterest: -->
      <section id="love-interest" class="pirate-profile">
        <span class="name">Elaine Marley</span>
      </section>
      """

  @has-widget
  Scenario: testing whether a sub-widget exists

    If you want to test whether the parent widget contains a given sub-widget,
    you can't send the widget(<widget_name>) message to the parent widget, as
    that will raise an exception. Instead, you can send
    `has_widget?(<widget_name>)`.

    Given the following widget:
      """
      class PirateProfile < Widget
        widget :name, '#name'
        widget :occupation, '#occupation'
      end
      """
    When I evaluate "widget(:pirate_profile).has_widget?(:name)"
    Then it should return "true"
    When I evaluate "widget(:pirate_profile).has_widget?(:occupation)"
    Then it should return "false"
    And the following should raise an exception:
      """
      widget(:pirate_profile).widget(:occupation)
      """
