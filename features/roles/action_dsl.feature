Feature: Action DSL

  The role DSL helps us write actions in a succint and readable way, reminiscent of Capybara's and Webrat's own DSLs. The big difference is that the role DSL works exclusively with widgets.

  Scenario: Visiting a page

    Given the following HTML at the path "/somewhere":
      """
      <div id="here"></div>
      """
    And the following widget definition:
      """
      Here = Dill::Widget('#here')
      """
    And the following role definition:
      """
      class Visitor < Dill::Role
        def go
          visit "/somewhere"
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = Visitor.new

      role.go
      """
    Then we should see the role did so:
      """
      widget?(:here) #=> true
      """

  @javascript
  Scenario: Clicking a widget

    `click :widget_name` is a shortcut for `widget(:widget_name).click`.

    Given the following HTML at the path "/somewhere":
      """
      <div id="clickme" onclick="this.innerHTML = 'Clicked!'">Click Me!</a>
      """
    And the following widget definition:
      """
      Clickme = Dill::Widget('#clickme')
      """
    And the following role definition:
      """
      class Clicker < Dill::Role
        def go
          visit "/somewhere"

          click :clickme
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = Clicker.new

      role.go
      """
    Then we should see the role did so:
      """
      widget(:clickme).text #=> "Clicked!"
      """

  @javascript
  Scenario: Submitting a form with some fields set

    `submit :form, ...` is a shortcut for `widget(:form).submit_with ...`.

    Given the following HTML at the path "/somewhere":
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="text" name="first_name" />
        <input type="text" name="last_name" />
        <input type="submit">
      </form>
      """
    And the following widget definition:
      """
      class MyForm < Dill::Form
        text_field :first_name, 'first_name'
        text_field :last_name, 'first_name'
      end
      """
    And the following role definition:
      """
      class Submitter < Dill::Role
        def go
          visit "/somewhere"

          submit :my_form, :first_name => 'Gubrush', :last_name => 'Threepwood'
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = Submitter.new

      role.go
      """
    Then we should see the role did so:
      """
      widget(:my_form).text #=> "Submitted!"
      """

  @javascript
  Scenario: Submitting a form with no fields set

    `submit :form` is a shortcut for `widget(:form).submit`.

    Given the following HTML at the path "/somewhere":
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="submit">
      </form>
      """
    And the following widget definition:
      """
      class EmptyForm < Dill::Form; end
      """
    And the following role definition:
      """
      class EmptySubmitter < Dill::Role
        def go
          visit "/somewhere"

          submit :empty_form
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = EmptySubmitter.new

      role.go
      """
    Then we should see the role did so:
      """
      widget(:empty_form).text #=> "Submitted!"
      """

  @javascript
  Scenario: Setting a form's values without submitting them

    `set :form, ...` is a shortcut for `widget(:form).set ...`.

    Given the following HTML at the path "/somewhere":
      """
      <form onsubmit="this.innerHTML = 'Submitted!'; return false">
        <input type="text" name="text_field">
      </form>
      """
    And the following widget definition:
      """
      class SetForm < Dill::Form
        text_field :text_field, 'text_field'
      end
      """
    And the following role definition:
      """
      class Setter < Dill::Role
        def go
          visit "/somewhere"

          set :set_form, :text_field => 'Value!'
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = Setter.new

      role.go
      """
    Then we should see the text field value has been changed:
      """
      widget(:set_form).text_field #=> "Value!"
      """
    But the form shouldn't have been submitted:
      """
      widget(:set_form).text #=> ""
      """
