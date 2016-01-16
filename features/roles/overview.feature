Feature: Overview

  Scenario: Defining a role

    You declare a role by inheriting from `CapybaraUI::Role`:

    Given the following role definition:
      """
      class Gardener < CapybaraUI::Role; end
      """
    Then we can use the role as we do any other Ruby object:
      """
      Gardener.new
      """

  @javascript
  Scenario: Roles group actions

    [We said before](../roles) that roles group actions. Usually those actions involve the following:

    1. Visiting a certain path (or more). Use `visit` and pass it a path, just like with Capybara. You can use Rails path helpers inside role actions.

    2. Interacting with a widget (or more). These widgets can be defined [inside the role](macros/widget#basic-usage), or outside (below).

    Given the following HTML at the path "/garden":
      """
      <a id="plants" onclick="this.innerHTML = 'Watered!'">Water plants</div>
      """
    And the following widget definition:
      """
      WaterPlants = CapybaraUI::Widget('#plants')
      """
    And the following role definition:
      """
      class Gardener < CapybaraUI::Role
        def water_plants
          visit garden_path

          click :water_plants
        end
      end
      """
    When we ask the role to execute the action:
      """
      gardener = Gardener.new

      gardener.water_plants
      """
    Then we should see the role did so:
      """
      widget(:water_plants).text #=> 'Watered!'
      """
