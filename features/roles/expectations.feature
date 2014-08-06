Feature: Expectations

  This is just a way to make role-based expectations read a little beter. We make the role the base of the expectation, and pass a widget selector (widget name and any required arguments for that widget) to it.

  Scenario: Seeing widgets through a role

    `see` sees widgets internal and external to the role

    Given the following HTML:
      """
      <div id="seen-inner">Seen Inner!</div>
      <div id="seen-outer">Seen Outer!</div>
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
    Then we should be able to see that the widgets exist:
      """
      seer = Seer.new

      expect(seer).to see :seen_inner
      expect(seer).to see :seen_outer
      """

  Scenario: Passing selector arguments to `see`

    Since you can only find some widgets by passing in additional arguments, `see` accepts additional arguments as well.

    Given the following HTML:
      """
      <div class="seen">Seen Outer!</div>
      <div class="seen">Seen Inner!</div>
      """
    And the following role definition:
      """
      class Seer < Dill::Role
        widget :seen, -> (position) { ['.seen', :text => /#{position}/] }
      end
      """
    Then we should be able to see that the widgets exist:
      """
      seer = Seer.new

      expect(seer).to see :seen, 'Inner'
      """

  Scenario: Delegating to role.see_*

    Sometimes, what we want the role to see may not map directly to a widget. In those
situations, we can define a custom `see_XXX?` method in the role, which will be used by the generic `see` matcher.

    Given the following role definition:
      """
      class Seer < Dill::Role
        def see_vapor?
          true
        end

        def see_ice?
          false
        end
      end
      """
    Then we should be able to use the "see_*" method:
      """
      seer = Seer.new

      expect(seer).to see :vapor
      expect(seer).not_to see :ice
      """

  Scenario: Passing arguments to role.see_*

    `see` passes all arguments except the first to the delegate method.

    Given the following role definition:
      """
      class Seer < Dill::Role
        def see_something?(arg)
          arg == "nice"
        end
      end
      """
    Then we should be able to use the "see_*" method:
      """
      seer = Seer.new

      expect(seer).to see :something, "nice"
      """
