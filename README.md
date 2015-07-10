# Dill
[![Travis Build Status](https://travis-ci.org/mojotech/dill.svg?branch=master)](https://travis-ci.org/mojotech/dill)
[![Code Climate](https://codeclimate.com/github/mojotech/dill/badges/gpa.svg)](https://codeclimate.com/github/mojotech/dill)
[![Test Coverage](https://codeclimate.com/github/mojotech/dill/badges/coverage.svg)](https://codeclimate.com/github/mojotech/dill)

Cucumber helpers to make it easier to write living documentation in Ruby.

See the documentation at https://www.relishapp.com/mojotech/dill/docs.

=======

#Overview
Dill is designed to work as a DOM interaction tool. Dill emphasizes relying on DOM attributes, rather than text, as attributes tend to be more stable.

Dill might best be thought of as three layers:

    ROLES, that perform => TASKS, which manipulate => ELEMENTS

Table of Contents
  - [Walkthrough](#walkthrough)
  - [Widgets](#widgets)

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


#Widgets<a name="widgets"></a>
A widget is the fundamental Dill element. A widget wraps a DOM element, allowing you to call methods on that element, like checking for text or clicking.

A widget is declared with the `widget` macro. Widgets take a CSS selector as the first argument.

```ruby
  widget :todo_item, '.todo-item'
```


## Nested Widgets
Widgets can be defined within widgets. CSS classes of child widgets are scoped within the class of the parent widget.

Child widgets are available via the `widget` method.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, '.todo-item' do
    widget :delete_link, '.delete' # :delete_link looks for a .delete class within a .todo-item element
  end

  # to access the delete_link widget:
  # widget(:todo_item).widget(:delete_link)
end

```


## Widget Methods
You can define custom methods on a widget object, or use the built-in methods.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, '.todo-item' do
    widget :delete_link, '.delete'

    def delete
      click :delete_link
    end
  end

  def delete_item
    widget(:todo_item).delete
  end

  def can_delete?
    # check for widget presence with the widget? method
    widget(:todo_item).widget?(:delete_link)
  end
end

```

## Widgets As Procs
Widgets can take a Proc instead of just a class, allowing us to more precisely define the widget at call time.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] } do
    widget :delete_link, '.delete'

    def delete
      click :delete_link
    end
  end

  def delete_item(description)
    # find the widget that includes the
    # description text and click delete

    widget(:todo_item, description).delete
  end
end

```

## Widgets Wait to Find an Element
Widgets block, meaning they pause code execution, and check the page for that element until they find it or they reach Capybara's timeout limit. This is handy for dynamic UI tests.

```ruby
  roles.myrole.create_todo_item("Buy Milk")
  # the item form is submitted to server and on response
  # from the server, a new item is appended to the list.
  # 'widget' waits until the item appears on the list,
  # or Capybara's timeout limit is reached

  expect(roles.myrole).to see :todo_item, "Buy Milk"
```

## Widget Root
The **root** of a widget is the element itself, a bit like `this` is in Javascript.

```ruby
class TodoManager < Dill::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] } do
    def delete
      root.find('a.delete').click
    end
  end
end

```


##To Be Continued...

Stay tuned for more in depth documentation of the following:

Dill Gotchas - the most common, unexpected Dill errors and solutions
Addressing irregular test failures with Dill
Dill Elements
  - lists
  - list-tables
  - forms
  - form-fields
