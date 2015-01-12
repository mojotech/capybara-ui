require 'dill/assertions'
require 'rspec/matchers'

RSpec::Matchers.define :see do |widget_name, *args|
  include Dill::Assertions

  match do |role|
    assert_visible(role, widget_name, *args)
  end

  match_when_negated do |role|
    assert_not_visible(role, widget_name, *args)
  end
end
