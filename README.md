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

#A Dill Walkthrough
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

##To Be Continued...

That's a quick tour of the basic Dill features, but there's a lot more! Stay tuned for more in depth documentation of the following:

Dill Gotchas - the most common, unexpected Dill errors and solutions
Addressing irregular test failures with Dill
Dill Elements
  - widgets
  - lists
  - list-tables
  - forms
  - form-fields
