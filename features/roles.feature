Feature: Roles

  Use a [role](https://github.com/mojotech/dill/blob/master/lib/dill/role.rb)
  whenever you want to group actions that are specific to a certain kind of
  user, or to a user performing tasks in a certain context.

  For example, if you have an app with a public area, an area that is specific
  to registered users and an area that is specific to admins, then you may have
  3 different roles: visitor, user and admin. But you may want to sub-divide
  these roles even further: a user that is managing their account performs a
  different set of tasks than does a user that is shopping.

  Scenario: Defining a role

    You declare a role by inheriting from `Dill::Role`:

    Given the following role definition:
      """
      class Gardener < Dill::Role; end
      """
    Then we can use the role as we do any other Ruby object:
      """
      Gardener.new
      """

  @javascript
  Scenario: Roles group actions

    We said above that roles group actions. Usually those actions involve the
    following:

    1. Visiting a certain path.
    2. Interacting with a number of widgets.

    Given the following HTML at the path "/garden":
      """
      <a id="plants" onclick="this.innerHTML = 'Watered!'">Water plants</div>
      """
    And the following widget definition:
      """
      WaterPlants = Dill::Widget('#plants')
      """
    And the following role definition:
      """
      class Gardener < Dill::Role
        def water_plants
          visit garden_path

          click :water_plants
        end
      end
      """
    When we ask the the role to execute the action:
      """
      gardener = Gardener.new

      gardener.water_plants
      """
    Then we should see the role did so:
      """
      widget(:water_plants).text #=> 'Watered!'
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
    Then we should be able to see that the widget exists:
      """
      seer = Seer.new

      seer.widget?(:seen_inner) #=> true
      """

  Scenario: declaring a role-specific form

    Although we can use the `widget` macro to declare a form, Dill provides a
    slightly more convenient way to do it, using the `form` macro.

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

  Scenario: seeing a widget through a role

    This is just a way to make role-based expectations read a little beter. We
    make the role the base of the expectation, and pass a widget selector
    (widget name and any required arguments for that widget) to it.

    Sometimes, what we want the role to see may not map directly to a widget. In
    those situations, we can define a custom `see_XXX?` method, which will be
    used by the generic `see` matcher.

    Given the following HTML:
      """
      <div id="seen-outer" class="seen">Seen Outer!</div>
      <div id="seen-inner" class="seen">Seen Inner!</div>
      """
    And the following widget definition:
      """
      SeenOuter = Dill::Widget('#seen-outer')
      """
    And the following widget definition:
      """
      Seen = Dill::Widget(-> (position) { ['.seen', :text => /#{position}/] })
      """
    And the following role definition:
      """
      class Seer < Dill::Role
        widget :seen_inner, "#seen-inner"

        def see_vapor?
          true
        end

        def see_more_vapor?(arg)
          false
        end
      end
      """
    Then we should be able to see that the widgets exist:
      """
      seer = Seer.new

      expect(seer).to see :seen_inner
      expect(seer).to see :seen_outer
      expect(seer).to see :seen, 'Inner'
      expect(seer).to see :vapor
      expect(seer).not_to see :more_vapor, 'yo'
      """
