# Capybara-UI Roles

##Table of Contents
  - [Roles Overview](#roles-overview)
  - [Setting up Roles in Cucumber](#setting-up-roles-in-cucumber)

## Roles Overview
Roles give you scoped storage for reuseable methods and widget definitions.

Given the following role definition:

```ruby
module Roles
  class AdminUser < Capybara::UI::Role
    widget :todo_item, '.todo-item'
    widget :delete_button, '.todo-item .delete'

    def delete_item
      click :delete_button
    end
  end
end
```

You should be able to call that method from your tests:

```ruby
role = AdminUser.new

role.delete_item
expect(role).not_to see :todo_item
```


## Setting up roles in Cucumber
> First require Capybara-UI's Cucumber library according to the readme.

It's fairly straightforward to make working with multiple roles very easy.
Given a role file in `features/support/roles/` called `admin_user.rb` that looks like this:

```ruby
  module Roles
    class AdminUser < Capybara::UI::Role
      def speak
        "I exist!"
      end
    end
  end
```

In your `features/support` file, add a file called `roles.rb` and define your admin user role.

```ruby
module Roles
  class << self
    def admin_user
      AdminUser.new
    end
  end

  def roles
    Roles
  end
end

World Roles
```

You can now access your admin user in your Cucumber steps with:

```ruby
roles.admin_user.speak #=> "I exist!"
```
