# Dill
[![Travis Build Status](https://travis-ci.org/mojotech/dill.svg?branch=master)](https://travis-ci.org/mojotech/dill)
[![Code Climate](https://codeclimate.com/github/mojotech/dill/badges/gpa.svg)](https://codeclimate.com/github/mojotech/dill)
[![Test Coverage](https://codeclimate.com/github/mojotech/dill/badges/coverage.svg)](https://codeclimate.com/github/mojotech/dill)

Cucumber helpers to make it easier to write living documentation in Ruby.

See the documentation at https://www.relishapp.com/mojotech/dill/docs.

#Overview
Dill is designed to work as a DOM interaction tool. Dill emphasizes relying on DOM attributes, rather than text, as attributes tend to be more stable.

Dill might best be thought of as three layers:

    ROLES, that perform => TASKS, which manipulate => ELEMENTS

##Table of Contents
  - [Walkthrough](#walkthrough)
  - [Widgets](#widgets)
  - [Forms](#forms)
  - [Field Groups](#field-groups)
  - [Lists](#lists)


#A Dill Walkthrough<a name="walkthrough"></a>
For this walkthrough, we're going to write an Rspec test using Dill. If we use these concepts of Roles, Tasks and Elements, our test might end up looking something like this:

```
describe 'Admin' do
  it 'should be able to create a new user' do
    params = { name: 'Example', email: 'example@example.com' }

    roles.admin.navigate_to_new_user
    roles.admin.create_user(params)

    expect(roles.admin).to see :new_user_message
  end
end
```

You can start to see in the expect statement that Dill is magical, too.

##Roles
A Dill role groups tasks and elements together, and is defined as a class.

```ruby
class Admin < Dill::Role
  ...
end
```

##Tasks
A task is just a method on a role.

```ruby
class Admin < Dill::Role
  def navigate_to_new_user
    ...
  end

  def create_user(params)
    ...
  end

  ...
end
```

##Elements
Elements are where the Dill amazingness begins, as well as where the Dill confusion heats up. Elements are dom abstractions that allow for precise testing. By using dom element attributes we can easily create the most basic Dill Element, a widget.

```ruby
class Admin < Dill::Role
  widget :new_user_button, 'a.add-user'
end
```

This widget uses css selectors to search the page for a link with the `add-user` class. That dom element is then wrapped into a Dill object, complete with a useful interface.

```ruby
  widget(:new_user_button).text # => 'Add a new user'
```

Building on our example, we can now click the link.

```ruby
class Admin < Dill::Role
  def navigate_to_new_user
    click :new_user_button
  end

  def create_user(params)
    ...
  end

  ...
end
```

Dill has a small arsenal of elements that work nicely with some of the more difficult-to-test DOM elements. Here is a **form** element, where we map the form widget to field sub-widgets, again using DOM attributes (here we're using names).

```ruby
class Admin < Dill::Role
  def navigate_to_new_user
    click :new_user_button
  end

  form :new_user_form, 'form.new-user' do
    text_field :name, 'user'
    text_field :email, 'email'
  end

  def create_user(changes)
    submit :new_user_form, changes
  end

  ...
end
```

Finally, let's explore that Dill magic in the expect clause. Dill's `see` expectation method, by default, will simply check for the presence of a widget by that name.

```ruby
class Admin < Dill::Role
  def navigate_to_new_user
    click :new_user_button
  end

  form :new_user_form, 'form.new-user' do
    text_field :name, 'user'
    text_field :email, 'email'
  end

  def create_user(changes)
    submit :new_user_form, changes
  end

  widget :new_user_message, '.flash.new-user-success'
end
```


#Widgets
A widget is the fundamental Dill element. A widget abstracts a DOM element, allowing you to call methods on that element, like checking for text or submitting a form.


## Widget Declaration
A widget can be declared with the `widget` macro, or as a class.

Macro widget declarations take a CSS or XPath selector as the first argument.

```ruby
widget :todo_item, '.todo-item'
widget :todo_item, [:xpath, '//some/node']
```

Class widget declarations define the widget with selector via the `root` method.

```ruby
class TodoItem < Dill::Widget
  root '.todo-item'
end

class TodoItem < Dill::Widget
  root :xpath, '//some/node'
end
```


## Widgets with Procs
Widgets can take a Proc in addition to a CSS selector or XPath expression, allowing us to more precisely define the widget at call time.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] }

  def select_item(description)
    click :todo_item, description
  end
end
```


## Widgets Wait to Find an Element
The `widget` method blocks, meaning it pauses Ruby code execution, and checks the page for that element until found or it reaches Capybara's timeout limit. It does not pause JavaScript code execution. This is handy for dynamic UI tests.

```ruby
roles.myrole.create_todo_item("Buy Milk")
# the item form is submitted to server and on response
# from the server, a new item is appended to the list.
# 'widget' waits until the item appears on the list,
# or Capybara's timeout limit is reached

expect(roles.myrole).to see :todo_item, "Buy Milk"
```


## Widget Root
The **root** of a widget is the Capybara element itself that Dill abstracts. When a widget is declared with the widget macro, the root declaration is implicit and equal to the element with the css class in the definition.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, '.todo-item' do
    def delete
      root.find('a.delete').click
    end
  end
end
```


## HTML Attributes
You can access the id and classes of the widget as well with Dill methods. Other attributes can be accessed from the Capybara element, via the `root` method.

```ruby
# <a href="/items/1" id="todo_item" class="todo-item right-aligned">
widget(:todo_item).id #=> "todo_form"
widget(:todo_item).classes #=> ["todo-item", "right-aligned"]
widget(:todo_item).root['href'] #=> "/items/1"
```


## Getting All the Widgets
You can get a list of all the elements that match your selector(s) on the page with the `widgets` method.

```ruby
# note: `widgets` does not wait like `widget` does
widgets(:todo_item)
```


## Nested Widgets
Widgets can be nested inside other widgets. Definining attributes of the inner widget, such as classes, will be scoped to within the outer widget.

```ruby
widget :todo_item, '.todo-item' do
  widget :delete_link, 'a.delete'
end
```

And can be called from that widget.

```ruby
widget(:todo_item).click :delete_button
```


## Widget Custom Methods
You can define custom methods on a widget object.

```ruby
class TodoManager < Dill::Role
  # see the Forms section for more information about form widgets
  form :new_email, '#new_email' do
    text_field :email, ["[id ^= 'email_addresses_']"]

    def body=(body)
      page.execute_script <<-JS
        jQuery('#email_body').data('wysihtml5').setValue(#{body.inspect});
        setTimeout(function() { $('#email_body').trigger('change') }, 500);
      JS
    end
  end

  def send_email(body)
    submit :new_email, body: "My test email body content."
  end
end
```


#Forms
Forms inherit all the properties of widgets, and have some of their own.


## Form Declaration
```ruby
  # with explicit class
  widget :todo_form, '.todo-form', Dill::Form

  # with the form macro
  form :todo_form, '.todo-form'
```


## Form Fields
Forms can have form-field widgets defined, as well as any regular sub-widgets. Form field widgets by default try to match their second argument with the text of a label, an input name or an input id.

```ruby
  form :form_with_everything, '.form-with-everything' do
    # text field
    text_field :request, 'request'

    # select field
    select :state, 'state'

    # checkbox field
    check_box :receive_email, 'receive_email'

    # regular sub-widget
    widget :hidden_field, '.hidden-field'

    # currently no built-in form support for radio buttons.
  end
```


#### Defining Fields with CSS Selectors
If you'd rather use a CSS selector, you can do that by passing the second argument as an array, with the selector as the array's first element.

```ruby
  text_field :request, ['.request-field-class'],
```


#### Getting Field Values
You can get the current value of any of these elements at any time by referencing them on the form object.

```
  widget(:form_with_everything).state #=> 'CO'
```


## Submitting a Form
Dill will easily submit a form for you, via the UI, with either of these methods.

```ruby
  params = { request: 'Call me', state: 'CO', receive_email: true }

  # the submit macro
  submit :form_with_everything, params

  # the submit widget method
  widget(:form_with_everything).submit_with(params)
```

You can also submit a form by setting the fields individually.
```ruby
  widget(:form_with_everything).tap do |f|
    f.request = 'Call me'
    f.state = 'CO'
    f.receive_email = true
    f.submit
  end
```

If you'd prefer to just set the fields without submitting the form, Dill can handle that, too, with the `set` macro, or the `set` method on the form widget.
```ruby
  set :form_with_everything, params

  widget(:form_with_everything).set params
```


#Field Groups
A field group is like a form without a submit button. It has all the same functionality as a Form object, minus the submitting function.


## Field Group Declaration
```ruby
  widget :todo_form, '.todo-form', Dill::FieldGroup
```


# Lists
A list is a collection of Dill ListItem objects, and is a good way to map a simple list format with a Dill element.


## List Declaration
```ruby
  # with explicit class
  class TodoList < Dill::List
    root '.todo-list'
  end

  # with widget macro and explicit class
  widget :todo_list, '.todo-list', Dill::List

  # with the list macro
  list :todo_list, '.todo-list'
```


## List Items
A List has access to its items, defined with a CSS selector.

```ruby
  list :todo_list, '.todo-list' do
    item 'li'
  end

  widget(:todo_list).items
```

List items are just a form of widget, and can have methods defined on them.

```ruby
  list :todo_list, '.todo-list' do
    item 'li' do
      def downcased
        text.downcase
      end
    end
  end
```

Inside the list, you can access all of its items.

```ruby
  list :todo_list, '.todo-list' do
    item 'li'

    def view_items_as_rows
      # list has Enumerable!
      items.map { |item| item.to_row }
    end
  end
```

If you only care about the list items themselves, it might be better to define the items as widgets.

```ruby
  # now when you go to find your item,
  # Dill will wait for that item to appear
  widget :todo_list_item, '.todo-list-item'
```


##To Be Continued...

Stay tuned for more in-depth documentation of the following:

- Dill Gotchas - the most common, unexpected Dill errors and solutions
- Addressing irregular test failures with Dill
