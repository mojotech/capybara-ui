#A CapybaraUI Walkthrough
CapybaraUI might best be thought of as three layers.

    ROLES, that perform => TASKS, which manipulate => ELEMENTS

For this walkthrough, we're going to write an Rspec test using CapybaraUI. If we use these concepts of Roles, Tasks and Elements, our test might end up looking something like this:

```ruby
describe 'Admin' do
  it 'should be able to create a new user' do
    params = { name: 'Example', email: 'example@example.com' }

    roles.admin.navigate_to_new_user
    roles.admin.create_user(params)

    expect(roles.admin).to see :new_user_message
  end
end
```

You can start to see in the expect statement that CapybaraUI is magical, too.


##Roles
A CapybaraUI role groups tasks and elements together, and is defined as a class.
See the [setting up roles](https://github.com/mojotech/capybara-ui/wiki/Setting-Up-Roles) section in the wiki for more how-to ideas.

```ruby
class Admin < CapybaraUI::Role
  ...
end
```


##Tasks
A task is just a method on a role.

```ruby
class Admin < CapybaraUI::Role
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
Elements are where the CapybaraUI amazingness begins, as well as where the CapybaraUI confusion heats up. Elements are dom abstractions that allow for precise testing. By using dom element attributes we can easily create the most basic CapybaraUI Element, a widget.

```ruby
class Admin < CapybaraUI::Role
  widget :new_user_button, 'a.add-user'
end
```

This widget uses css selectors to search the page for a link with the `add-user` class. That dom element is then wrapped into a CapybaraUI object, complete with a useful interface.

```ruby
  widget(:new_user_button).text # => 'Add a new user'
```

Building on our example, we can now click the link.

```ruby
class Admin < CapybaraUI::Role
  def navigate_to_new_user
    click :new_user_button
  end

  def create_user(params)
    ...
  end

  ...
end
```

CapybaraUI has a small arsenal of elements that work nicely with some of the more difficult-to-test DOM elements. Here is a **form** element, where we map the form widget to field sub-widgets, again using DOM attributes (here we're using names).

```ruby
class Admin < CapybaraUI::Role
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

Finally, let's explore that CapybaraUI magic in the expect clause of our example spec. CapybaraUI's `see` expectation method, by default, will simply check for the presence of a widget by that name.

```ruby
class Admin < CapybaraUI::Role
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

That's it for the walkthrough, but CapybaraUI has a lot more to offer. We recommend digging into Widgets next, as Widget is the fundamental class common to all the CapybaraUI elements.


