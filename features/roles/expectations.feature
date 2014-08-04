Feature: Expectations

  Scenario: seeing a widget through a role

    This is just a way to make role-based expectations read a little beter. We make the role the base of the expectation, and pass a widget selector (widget name and any required arguments for that widget) to it.

    Sometimes, what we want the role to see may not map directly to a widget. In those situations, we can define a custom `see_XXX?` method, which will be used by the generic `see` matcher.

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
