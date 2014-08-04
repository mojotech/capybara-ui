Dill comprises a set of helpers designed to help you write "literate tests" (tests written as living documentation).

Currently, Dill's main focus is end-to-end testing, but we certainly don't intend to stop here. Watch this space.

## Requirements

* Cucumber 1.3 or later
* Rails 3.2 or later

## Installation

Once you have Cucumber setup in your Rails project, add the following to `features/support/env.rb`, or some other file:

```
require 'dill/cucumber'
```

## End-to-end testing

Dill lets you interact with page elements via [widgets](widgets). We initially intended them to be an implementation of the [Page Object](http://martinfowler.com/bliki/PageObject.html) pattern, which typically means that you interact with each widget solely through its custom-defined API.

So you would, for example, define the following widget:

*(Don't worry if you don't understand all of the details. We'll explain them later.)*

```ruby
class Plants < Dill::Widget
  root '#plants'

  widget :water, 'button.water-plants'

  def water
    click :water
  end
end
```

and then use it like this:

```ruby
widget(:plants).water
```

This is acceptable. If you change the way how you water the plants (for example, let's say you now need to confirm that you really want to water the plants) then you only need to change `#water`'s implementation, and everything works.

### The role-based approach

Even though the above approach works, it has a couple of drawbacks:

First, it hides UI interaction under another fragmented layer of indirection (not counting the one Dill already provides). If you need to interact with multiple widgets, you need to keep shifting contexts to understand, for example, what it means to call `#water` on `widget(:plants)`.

Second, a meaningful business action (say, "signing in") often involves interacting with more than one widget, forcing custom widget API's like `#water` to do little more than wrap, for example, a single click. Since it's in our best interest to uphold a Single Source of Truth, we'll want define what "signing in" means *in a single place*.

We settled on using widgets as a translation layer between the UI and the code, instead of letting them encapsulate meaningful business knowledge. That business knowledge is now handled by [roles](roles.feature).

So, you would define the following role, instead:

```ruby
class Gardener < Dill::Role
  widget :water_plants, 'button.water-plants'

  def water_plants
    visit plants_path

    click :water_plants
  end
end
```

and then use it like this:

```ruby
gardener = Gardener.new

gardener.water_plants
```
