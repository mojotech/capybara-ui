# CapybaraUI Docs
  Brand new to CapybaraUI? Try the [CapybaraUI walkthrough](walkthrough.md).

##Table of Contents
  - [Widgets](#widgets)
  - [Forms](#forms)
  - [Field Groups](#field-groups)
  - [Lists](#lists)
  - [Tables](#tables)
  - [Cucumber helpers](#cucumber-helpers)

See even more documentation at https://www.relishapp.com/mojotech/capybara-ui/docs.

#Widgets
A widget is the fundamental CapybaraUI element. A widget abstracts a DOM element, allowing you to call methods on that element, like checking for text or submitting a form.


## Widget Declaration
A widget can be declared with the `widget` macro, or as a class.

Macro widget declarations take a CSS or XPath selector as the first argument.

```ruby
widget :todo_item, '.todo-item'
widget :todo_item, [:xpath, '//some/node']
```

Class widget declarations define the widget with selector via the `root` method.

```ruby
class TodoItem < CapybaraUI::Widget
  root '.todo-item'
end

class TodoItem < CapybaraUI::Widget
  root :xpath, '//some/node'
end
```


## Widgets with Procs
Widgets can take a Proc in addition to a CSS selector or XPath expression, allowing us to more precisely define the widget at call time.

```ruby
class TodoManager < CapybaraUI::Role
  widget :todo_item, -> (text) { ['.todo-item', text: text] }

  def select_item(description)
    click :todo_item, description
  end
end
```


## Checking for Widgets on the Page
It is enough to call a widget to know if it is on the page. But we can also return a boolean with `#visible?` and `not_visible?`.

```ruby
widget(:todo_item, 'Buy Milk') # => returns widget object
visible?(:todo_item, 'Buy Milk') # => true
not_visible?(:todo_item, 'Buy Milk') # => false

widget(:todo_item, 'Write a Novel') # => raises CapybaraUI::MissingWidget error
visible?(:todo_item, 'Write a Novel') # => false
not_visible?(:todo_item, 'Write a Novel') # => true
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
The **root** of a widget is the Capybara element itself that CapybaraUI abstracts. When a widget is declared with the widget macro, the root declaration is implicit and equal to the element with the css class in the definition.

```ruby
class TodoManager < CapybaraUI::Role
  widget :todo_item, '.todo-item' do
    def delete
      root.find('a.delete').click
    end
  end
end
```


## UI Interactions
We can simulate a user interacting with a widget. Note not all methods will be supported by all drivers.

```ruby
# dsl methods
hover :todo_item
click :todo_item
double_click :todo_item
right_click :todo_item

# widget methods
widget(:todo_item).click
widget(:todo_item).hover
widget(:todo_item).double_click
widget(:todo_item).right_click

# nested widget methods
widget(:todo_item).click :delete_button
widget(:todo_item).hover :delete_button
widget(:todo_item).double_click :delete_button
widget(:todo_item).right_click :delete_button
```


## HTML and Attributes
You can access the id and classes of the widget as well with CapybaraUI methods. Other attributes can be accessed from the Capybara element, via the `root` method.

```ruby
# <a href="/items/1" id="todo_item" class="todo-item right-aligned">
widget(:todo_item).id #=> "todo_form"
widget(:todo_item).classes #=> ["todo-item", "right-aligned"]
widget(:todo_item).class?("todo-item") #=> true
widget(:todo_item).root['href'] #=> "/items/1"
```

You can also access the HTML of the element

```ruby
#  <a href="/items/1" id="todo_item" class="todo-item right-aligned"></a>
widget(:html).html # => "<a href=\"/items/1\" id=\"todo_item\" class=\"todo-item right-aligned\"></a>\n"
```

> Note: Some drivers like Poltergeist currently do not provide a way to view the HTML.


## Getting All the Widgets
You can get a list of all the elements that match your selector(s) on the page with the `widgets` method.

```ruby
# note: `widgets` does not wait like `widget` does
widgets(:todo_item)
```


## Nested Widgets
Widgets can be nested inside other widgets. Definining attributes of the inner widget, such as classes, will be scoped to within the outer widget.

> Note: Nested widgets and instance methods like #click will not wait for the element to appear.

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
class TodoManager < CapybaraUI::Role
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
  widget :todo_form, '.todo-form', CapybaraUI::Form

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

    # radio button field group
    radio_button :favorite_color, '.favorite-color-parent'

    # regular sub-widget
    widget :hidden_field, '.hidden-field'
  end
```

> Note: Radio buttons share the same name, and so must be treated differently. Define a group of radio buttons via a parent element, using standard css selectors rather than field-specific selectors.

#### Defining Fields with CSS Selectors
If you'd rather use a CSS selector, you can do that by passing the second argument as an array, with the selector as the array's first element.

```ruby
  text_field :request, ['.request-field-class'],
```


#### Form Field Values
You can get the current value of form elements by calling their methods, automagically defined by CapybaraUI.

```ruby
  widget(:form_with_everything).state #=> 'CO'
  widget(:form_with_everything).request #=> 'Please send me more info'
  widget(:form_with_everything).receive_email #=> true
```

For text fields, check for content by calling the method + question mark.

```ruby
  # <input type="text" value="Please send me more info">
  widget(:form_with_everything).request? # => true
  # <input type="text" value="">
  widget(:form_with_everything).request? # => false
```

For select fields, the default method returns the selected option's text. Call the `<name>_value` method to return the value of the selected option.

```ruby
  # <option value="38" selected>CO</option>
  widget(:form_with_everything).state # => CO
  widget(:form_with_everything).state_value # => "38"
```

For **radio button** field groups, the default method returns the checked button's label text. Call the `<name>_value` method to return the value of the checked button.

```ruby
  # <label for="b">Blue</label>
  # <input type="radio" id="b" value="#0033CC" checked>
  widget(:form_with_everything).favorite_color # => Blue
  widget(:form_with_everything).favorite_color_value # => "#0033CC"
```


## Submitting a Form
CapybaraUI will easily submit a form for you, via the UI, with either of these methods.

```ruby
  params = { request: 'Call me', state: 'CO', receive_email: true, favorite_color: 'blue' }

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

If you'd prefer to just set the fields without submitting the form, CapybaraUI can handle that, too, with the `set` macro, or the `set` method on the form widget.
```ruby
  set :form_with_everything, params

  widget(:form_with_everything).set params
```


#Field Groups
A field group is like a form without a submit button. It has all the same functionality as a Form object, minus the submitting function.


## Field Group Declaration
```ruby
  widget :todo_form, '.todo-form', CapybaraUI::FieldGroup
```


# Lists
A list is a collection of CapybaraUI ListItem objects, and is a good way to map a simple list format with a CapybaraUI element. (For more complicated lists, consider the [table](#tables) element.)


## List Declaration
```ruby
  # with explicit class
  class TodoList < CapybaraUI::List
    root '.todo-list'
  end

  # with widget macro and explicit class
  widget :todo_list, '.todo-list', CapybaraUI::List

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
  # CapybaraUI will wait for that item to appear
  widget :todo_list_item, '.todo-list-item'
```


# Tables
Table widgets map tables, or table-like DOM structures that have a header and data rows.


## Default vs Custom Tables
Default Table widgets define the root as a `table` element, headers as `thead > tr`, and data rows as `tbody > tr`. Both headers and rows have a default column of `td`.

Custom tables allow you to map a CapybaraUI::Table element over a table-like structure.


## Default Table Declaration
```ruby
  # with explicit class
  class TodoTable < CapybaraUI::Table
  end

  # with widget macro and explicit class
  widget :todo_table, CapybaraUI::Table
```


## Custom Table Declaration
```ruby
  # with explicit class
  class TodoTable < CapybaraUI::Table
    root '.todo-table'
  end

  # with widget macro and explicit class
  widget :todo_table, '.todo-table', CapybaraUI::Table
```


## Custom Header and Data Row Definitions
Tables allow you to define the header row and data rows by class.

Given this HTML...
```html
<ul class="todo-table">
  <li class="header-row">
    <span>Header Col 1</span>
    <span>Header Col 2</span>
    <span>Header Col 3</span>
  </li>
  <li class="data-row">
    <span>Val 1.1</span>
    <span>Val 1.2</span>
    <span>Val 1.3</span>
  </li>
  <li class="data-row">
    <span>Val 2.1</span>
    <span>Val 2.2</span>
    <span>Val 2.3</span>
  </li>
</ul>
```

... You can define the headers, data_rows and their columns with CSS selectors.

```ruby
widget :todo_table, '.todo-table', CapybaraUI::Table do
  header_row '.header-row' do
    column 'span'
  end

  data_row '.data-row' do
    column 'span'
  end
end
```


## Table Values
In both default and custom tables, you can get the values in a row, or in a column.

```ruby
  widget(:list_table).rows[0] #=> ['Val 1.1', 'Val 1.2']
  widget(:list_table).columns[2] #=> ['Val 1.3', 'Val 2.3']
  widget(:list_table).columns['Header Col 2'] #=> ['Val 1.2', 'Val 2.2']
```


# Cucumber helpers
CapybaraUI currently provides a single method to work with Cucumber tables.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  # when the cucumber table values do not match the widget's values
  widget(:my_widget).diff table # raises error Cucumber::Ast::Table::Different

  # when the cucumber table values match the widget's values
  widget(:my_widget).diff table # => true
 end
```

Pass `ignore_case: true`, for a case-insensitive table match.

```ruby
Then(/^some step that takes in a cucumber table$/) do |table|
  widget(:my_widget).diff table, ignore_case: true
end
```

#To Be Continued...
Stay tuned for more documentation of the following:
- CapybaraUI Gotchas - the most common, unexpected CapybaraUI errors and solutions
- Addressing irregular test failures with CapybaraUI
- CapybaraUI's rspec 'see' method
