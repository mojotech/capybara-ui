Feature: Role

  A Role is a way to group actions related to certain kinds of users. Inside a
  Role you have access to the following:

  * Dill's DSL
  * Rails path helpers
  * RSpec expectations

  @javascript
  Scenario: declaring a role
    Given the following HTML at the path "/garden":
      """
      <div id="plants" onclick="this.innerHTML = 'Watered!'">Thirsty!</div>
      """
    And the following widget definition:
      """
      class Plants < Dill::Widget
        root '#plants'

        action :water
      end
      """
    And the following role definition:
      """
      class Gardener < Dill::Role
        def water_plants
          visit garden_path

          widget(:plants).water
        end
      end
      """
    When we ask the gardener to water the plants:
      """
      gardener = Gardener.new
      gardener.water_plants
      """
    Then we should see the plants have been watered:
      """
      widget(:plants).text #=> 'Watered!'
      """

  Scenario: declaring a role-specific widget

    Widgets can be declared in roles in the usual ways. An especially handy one
    is the same .widget macro that is used to declare widgets inside other
    widgets.

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
    Then we should be able to see that the widget :seen_inner exists:
      """
      seer = Seer.new

      expect(seer.widget?(:seen_inner)).to be_true
      """
