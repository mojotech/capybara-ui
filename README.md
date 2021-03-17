# Capybara-UI
[![Code Climate](https://codeclimate.com/github/mojotech/capybara-ui/badges/gpa.svg)](https://codeclimate.com/github/mojotech/capybara-ui)
[![Test Coverage](https://codeclimate.com/github/mojotech/capybara-ui/badges/coverage.svg)](https://codeclimate.com/github/mojotech/capybara-ui)

Docs [here](/docs/table_of_contents.md). Check out the [wiki](https://github.com/mojotech/capybara-ui/wiki) for more ideas and tips.

# Overview
Capybara-UI (formerly called Dill) is a [Capybara](https://github.com/jnicklas/capybara) abstraction that makes it easy to define reuseable DOM "widgets", aka [page objects](http://www.assertselenium.com/automation-design-practices/page-object-pattern/), and introduces the concept of "roles" to allow you to easily organize your testing methods and widgets. Capybara-UI also introduces some helpers and syntactic sugar to make your testing even easier.

### Before Capybara-UI
```ruby
feature 'Admin new user page' do
  it 'should be able to create a new user' do
    visit('/users/new')

    within(:css, "#new_user") do
      fill_in('Name', :with => 'Example Name')
      fill_in('Password', :with => 'Password')
      select('Blue', :from => 'Favorite Color')
      click_button('Submit')
    end

    within(:css, '.alert-success') do
      expect(page).to have_content('Example Name')
    end
  end
end
```

### After Capybara-UI
```ruby
feature 'Admin new user page' do
  let(:role) { roles.admin }

  it 'should be able to create a new user' do
    role.navigate_to_new_user
    role.create_user(name: 'Example Name', password: 'Password', color: 'Blue')

    expect(role).to see :successfully_created_user, 'Example Name'
  end
end
```

For a more in depth tour of Capybara-UI, read the [Capybara-UI walkthrough](/docs/walkthrough.md). You can also get more ideas and tips from the [wiki](https://github.com/mojotech/capybara-ui/wiki).


## Install
Add the following line to your gemfile

```ruby
gem 'capybara-ui'
```

If using with Cucumber, add the following to your `support/env.rb`.

```ruby
require 'capybara/ui/cucumber'
```

If you are using with RSpec, add the following to your `spec_helper.rb` or
`support/env.rb` file.

```ruby
require 'capybara/ui/rspec'
```

## Contributing
We welcome pull requests. Please make sure tests accompany any PRs.


---

Curated by the good people at MojoTech.

<a href="http://mojotech.com"><img width="140px" src="https://mojotech.github.io/sass2stylus/img/mojotech-logo.svg" title="MojoTech's Hiring"></a> <sup>(psst, [we're hiring](http://www.mojotech.com/jobs))</sup>
