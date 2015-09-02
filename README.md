# Dill
[![Travis Build Status](https://travis-ci.org/mojotech/dill.svg?branch=master)](https://travis-ci.org/mojotech/dill)
[![Code Climate](https://codeclimate.com/github/mojotech/dill/badges/gpa.svg)](https://codeclimate.com/github/mojotech/dill)
[![Test Coverage](https://codeclimate.com/github/mojotech/dill/badges/coverage.svg)](https://codeclimate.com/github/mojotech/dill)

Docs [here](/docs/getting_started.md). Check out the wiki for more tips.

#Overview
Dill is a [Capybara](https://github.com/jnicklas/capybara) abstraction that helps to bring your testing language closer to your business language.

### Before Dill
```ruby
describe 'Admin' do
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

### After Dill
```ruby
describe 'Admin' do
  let(:role) { roles.admin }

  it 'should be able to create a new user' do
    role.navigate_to_new_user
    role.create_user(name: 'Example Name', password: 'Password', color: 'Blue')

    expect(role).to see :successfully_created_user, 'Example Name'
  end
end
```

For a more in depth tour of Dill, read the [Dill walkthrough](/docs/walkthrough.md).


## Documentation
Learn all about how to use Dill in the [official documentation](/docs/getting_started.md) or get real-world ideas and tips from the [wiki](https://github.com/mojotech/dill/wiki).


## Install
Add the following line to your gemfile

```ruby
gem 'dill', github: 'mojotech/dill'
```


## Contributing
We welcome pull requests. Please make sure tests accompany any PRs. Email Adam at ags@mojotech.com if you have questions.


---

Curated by the good people at MojoTech.

<a href="http://mojotech.com"><img width="140px" src="https://mojotech.github.io/jeet/img/mojotech-logo.svg" title="MojoTech's Hiring"></a> <sup>(psst, [we're hiring](http://www.mojotech.com/jobs))</sup>
