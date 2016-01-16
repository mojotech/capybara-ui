Use a [role](https://github.com/mojotech/capybara-ui/blob/master/lib/capybara-ui/role.rb) whenever you want to group actions that are specific to a certain kind of user, or to a user performing tasks in a certain context.

For example, if you have an app with a public area, an area that is specific to registered users and an area that is specific to admins, then you may have 3 different roles: visitor, user and admin. But you may want to sub-divide these roles even further: a user that is managing their account performs a different set of tasks than does a user that is shopping.
