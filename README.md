[![Travis Build Status](https://travis-ci.org/mojotech/dill.svg?branch=master)](https://travis-ci.org/mojotech/dill)

# Dill
Write tastier tests.

<center>
<img height="220px" src="https://raw.github.com/mojotech/dill/master/dill_logo.png"/>
</center>

## Installation

Add `dill` to your `Gemfile`. Then add `require 'dill/cucumber'` to `features/support/00_dill.rb`.

- We prefix the file name with `00_` to ensure it's loaded as soon as possible during cucumber boot.

## Documentation

See the docs for [master](http://rubydoc.info/github/mojotech/dill/master/frames).

## Widgets

The widgets API is an implementation of the
[Page Object](http://martinfowler.com/bliki/PageObject.html) pattern, with a twist.

### Your First Widget

Given the following HTML:

    <body>
      <span id="my-widget">My Widget</span>
    </body>

You can define a widget as follows:

    class MyWidget < Dill::Widget
      root '#my-widget'
    end

So, to create a widget, simply extend `Dill::Widget` (or one of its subclasses)
and define the widget's root element.

As long as you include `Dill::DSL` (done automatically if you require
`dill/cucumber`), you can then get a reference to the widget using `#widget`,
like this:

    my_widget = widget(:my_widget)

### Philosophy

A test is typically comprised of 3 phases: Arrange (Given), Act
(When) and Assert (Then). Widgets take a central roles in Act, and they provide helpful access to information you'll need when you Assert.

Widgets allow you to interact with your DOM in a more object-oriented manner. For example,
where, in Capybara, you would test if a node contains some text like this:

    expect(page).to have_selector('#my-widget', text: 'My Widget')

you can do the samething using Dill, like this:

    expect(widget(:my_widget)).to eq 'My Widget'

You can take advantage of the OO-nature of the widget API to customize how a
widget presents itself to the world. Just override the widget's `#value` method:

    class MyWidget < Dill::Widget
      root '#my-widget'

      def value
        # unsurprisingly, #text returns the widget's text
        text + ", eh?"
      end
    end

    # use it:

    expect(widget(:my_widget)).to eq 'My Widget, eh?'
    expect(widget(:my_widget)).to include 'My'

See
[the documentation for Dill::Widget](http://rubydoc.info/github/mojotech/dill/master/Dill/Widget)
for information on how to use basic widgets.

### Waiting on assertions

TODO

### Forms

TODO

### Lists

See [the documentation for Dill::List](http://rubydoc.info/github/mojotech/dill/master/Dill/List).

### Tables

TODO

## The top level document

TODO
