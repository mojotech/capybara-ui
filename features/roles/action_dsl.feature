Feature: Action DSL

  The role DSL helps us write actions in a succint and readable way, reminiscent of Capybara's and Webrat's own DSLs. The big difference is that the role DSL works exclusively with widgets.

  Scenario: Visiting a page

    Given the following HTML at the path "/somewhere":
      """
      <div id="here"></div>
      """
    And the following widget definition:
      """
      Here = CapybaraUI::Widget('#here')
      """
    And the following role definition:
      """
      class Visitor < CapybaraUI::Role
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
      visible?(:here) #=> true
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
      Clickme = CapybaraUI::Widget('#clickme')
      """
    And the following role definition:
      """
      class Clicker < CapybaraUI::Role
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
  Scenario: Hovering over a widget

    `hover :widget_name` is a shortcut for `widget(:widget_name).hover`.

    Given the following HTML at the path "/somewhere":
      """
      <div id="hoverme" onmouseover="this.innerHTML = 'Hovered!'">Hover Me!</a>
      """
    And the following widget definition:
      """
      Hoverme = CapybaraUI::Widget('#hoverme')
      """
    And the following role definition:
      """
      class Hoverer < CapybaraUI::Role
        def act
          visit "/somewhere"

          hover :hoverme
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = Hoverer.new

      role.act
      """
    Then we should see the role did so:
      """
      widget(:hoverme).text #=> "Hovered!"
      """

  @javascript
  Scenario: Double clicking a widget

    `double_click :widget_name` is a shortcut for `widget(:widget_name).double_click`.

    Given the following HTML at the path "/somewhere":
      """
      <div id="dblclickme" ondblclick="this.innerHTML = 'Double Clicked!'">Double Click Me!</a>
      """
    And the following widget definition:
      """
      DoubleClickMe = CapybaraUI::Widget('#dblclickme')
      """
    And the following role definition:
      """
      class DoubleClicker < CapybaraUI::Role
        def act
          visit "/somewhere"

          double_click :double_click_me
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = DoubleClicker.new

      role.act
      """
    Then we should see the role did so:
      """
      widget(:double_click_me).text #=> "Double Clicked!"
      """

  @javascript
  Scenario: Dragging a widget to another widget

    `drag(:source).to(:target)` is a shortcut for `widget(:source).drag_to(:target)`.

    Given the following HTML at the path "/somewhere":
      """
      <div id="source" draggable="true">Drag Me!</div>>
      <div id="target" ondragover="this.innerHTML = 'Dragged To Drop Zone!'">Drop Zone!</div>
      """
    And the following widget definitions:
      """
      Source = Dill::Widget('#source')
      Target = Dill::Widget('#target')
      """
    And the following role definition:
      """
      class Dragger < Dill::Role
        def act
          visit "/somewhere"

          drag(:source).to(:target)
        end
      end
      """
    When we ask the role to execute the action:
      """
      role = DoubleClicker.new

      role.act
      """
    Then we should see the role did so:
      """
      widget(:target).text #=> "Dragged To Drop Zone!""
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
      class MyForm < CapybaraUI::Form
        text_field :first_name, 'first_name'
        text_field :last_name, 'first_name'
      end
      """
    And the following role definition:
      """
      class Submitter < CapybaraUI::Role
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
      class EmptyForm < CapybaraUI::Form; end
      """
    And the following role definition:
      """
      class EmptySubmitter < CapybaraUI::Role
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
      class SetForm < CapybaraUI::Form
        text_field :text_field, 'text_field'
      end
      """
    And the following role definition:
      """
      class Setter < CapybaraUI::Role
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
